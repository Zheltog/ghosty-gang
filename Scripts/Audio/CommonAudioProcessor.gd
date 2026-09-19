extends Node

const default_music_volume: int = 100
const default_sound_volume: int = 100

const _sound_players_pool_size: int = 10

@onready var _music_player: TypedAudioStreamPlayer = $MusicPlayer
@onready var _default_sound_player: TypedAudioStreamPlayer = $SoundPlayer

static var music_volume: int = default_music_volume
static var sound_volume: int = default_sound_volume
static var relative_volumes: Dictionary = {}
static var tag_volumes: Dictionary = {}

var _sound_players_pool: Array[TypedAudioStreamPlayer] = []
var _looped_sound_players: Dictionary = {}
var _resource_cache: Dictionary = {}

func _ready() -> void:
	for i in range(_sound_players_pool_size):
		var sound_player = TypedAudioStreamPlayer.new()
		sound_player.type = TypedAudioStreamPlayer.AudioStreamPlayerType.Sound
		_sound_players_pool.append(sound_player)
		add_child(sound_player)

func process_music_volume_changed() -> void:
	_music_player.adjust_volume_instant()

func process_sound_volume_changed() -> void:
	_default_sound_player.adjust_volume_instant()
	for i in range(_sound_players_pool_size):
		_sound_players_pool[i].adjust_volume_instant()

func process_music(command: AudioMusicCommand) -> void:
	_process_context(_music_player, command.instant, command.post_action, command.resource_name, \
		command.adjustment_mode, command.adjustment_value, command.relative_volume, command.tag)

func process_sound(command: AudioSoundCommand) -> void:
	var player = _pick_sound_player()
	_reset_player_pitch(player)
	_process_context(player, command.instant, "", command.resource_name, \
		command.adjustment_mode, command.adjustment_value, command.relative_volume, command.tag)

func process_sound_random_pitch(command: AudioSoundRandomPitchCommand) -> void:
	var random_pitch = randf_range(command.pitch_from, command.pitch_to)
	var player = _pick_sound_player()
	player.pitch_scale = random_pitch
	# todo: no need to pass adjustment parameters at all
	_process_context(player, true, "", command.resource_name, \
		TypedAudioStreamPlayer.AdjustmentMode.BY_TIME, 0, command.relative_volume, command.tag)

func process_sound_looped(command: AudioSoundLoopedCoomand) -> void:
	var resource_name = command.resource_name
	var post_action = command.post_action
	if resource_name == null or resource_name == "":
		printerr("[CommonAudioProcessor] No looped sound resource name provided")
		return
	if resource_name == AudioConstants.ALL:
		if post_action == null or post_action == "":
			printerr("[CommonAudioProcessor] Post action should be provided for batch processing")
			return
		_process_post_action_for_all(post_action, command.instant, \
			command.adjustment_mode, command.adjustment_value)
		return
	if post_action != null and post_action != "":
		if not _looped_sound_players.has(resource_name):
			printerr("[CommonAudioProcessor] Looped sound is not processing: ", resource_name)
			return
		_process_post_action(_looped_sound_players[resource_name], post_action, command.instant, \
			command.adjustment_mode, command.adjustment_value)
		if post_action == AudioConstants.STOP:
			_looped_sound_players.erase(resource_name)
		return
	if _looped_sound_players.has(resource_name):
		printerr("[CommonAudioProcessor] Looped sound is already processing: ", resource_name)
		return
	var sound_player = _pick_sound_player()
	_reset_player_pitch(sound_player)
	_looped_sound_players[resource_name] = sound_player
	_process_resource(sound_player, resource_name, command.instant, command.adjustment_mode, \
		command.adjustment_value, command.relative_volume, command.tag)

func _process_context(player: TypedAudioStreamPlayer, instant: bool, post_action: String, resource_name: String, \
	adjustment_mode: TypedAudioStreamPlayer.AdjustmentMode, adjustment_value: float, \
	relative_volume: float, tag: String) -> void:
	if post_action != null and post_action != "":
		_process_post_action(player, post_action, instant, adjustment_mode, adjustment_value)
		return
	if resource_name == null or resource_name == "":
		printerr("[CommonAudioProcessor] No resource name")
		return
	_process_resource(player, resource_name, instant, adjustment_mode, adjustment_value, relative_volume, tag)

func _process_post_action_for_all(post_action: String, instant: bool, \
	adjustment_mode: TypedAudioStreamPlayer.AdjustmentMode, adjustment_value: float) -> void:
	for player in _looped_sound_players.values():
		_process_post_action(player, post_action, instant, adjustment_mode, adjustment_value)
	if post_action == AudioConstants.STOP:
		_looped_sound_players.clear()

func _process_post_action(player: TypedAudioStreamPlayer, post_action: String, instant: bool, \
	adjustment_mode: TypedAudioStreamPlayer.AdjustmentMode, adjustment_value: float) -> void:
	match post_action:
		AudioConstants.STOP:
			if instant:
				player.stop()
			else:
				player.adjust_volume_falling(adjustment_mode, adjustment_value, func(): player.stop())
		AudioConstants.PAUSE:
			if instant:
				player.stream_paused = true
			else:
				player.adjust_volume_falling(adjustment_mode, adjustment_value, func(): player.stream_paused = true)
		AudioConstants.RESUME:
			if instant:
				player.adjust_volume_instant()
			else:
				player.adjust_volume_rising(adjustment_mode, adjustment_value)
			player.stream_paused = false
		_:
			printerr("[CommonAudioProcessor] Unknown post action: ", post_action)

func _process_resource(player: TypedAudioStreamPlayer, resource_name: String, instant: bool, \
	adjustment_mode: TypedAudioStreamPlayer.AdjustmentMode, adjustment_value: float, \
	relative_volume: float, tag: String) -> void:
	player.play_resource(resource_name, _get_cached_stream(resource_name), tag)
	if relative_volume != 100:
		relative_volumes[resource_name] = relative_volume
	if instant:
		player.adjust_volume_instant()
	else:
		player.adjust_volume_rising(adjustment_mode, adjustment_value)

func _pick_sound_player() -> TypedAudioStreamPlayer:
	if _sound_players_pool_size == 0:
		return _default_sound_player
	for i in range(_sound_players_pool_size):
		var pooled_player: TypedAudioStreamPlayer = _sound_players_pool[i]
		if not pooled_player.playing:
			return pooled_player
	return _default_sound_player

func _reset_player_pitch(player: TypedAudioStreamPlayer) -> void:
	if player.pitch_scale != 1:
		player.pitch_scale = 1

func _get_cached_stream(resource_name: String) -> AudioStream:
	if _resource_cache.has(resource_name):
		return _resource_cache[resource_name]
	var stream = load(resource_name)
	if stream == null:
		printerr("[CommonAudioProcessor] Unknown resource: ", resource_name)
		return null
	_resource_cache[resource_name] = stream
	return stream
