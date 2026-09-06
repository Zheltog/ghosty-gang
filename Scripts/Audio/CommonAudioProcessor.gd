extends Node

const _volume_change_seconds: float = 1
const _sound_players_pool_size: int = 10

@onready var _music_player: TypedAudioStreamPlayer = $MusicPlayer
@onready var _default_sound_player: TypedAudioStreamPlayer = $SoundPlayer

static var music_volume: float = 100
static var sound_volume: float = 100

var _sound_players_pool: Array[TypedAudioStreamPlayer] = []
var _looped_sound_players: Dictionary = {}
var _resource_cache: Dictionary = {}

func _ready() -> void:
	for i in range(_sound_players_pool_size):
		var sound_player = TypedAudioStreamPlayer.new()
		sound_player.type = TypedAudioStreamPlayer.AudioStreamPlayerType.Sound
		_sound_players_pool.append(sound_player)
		add_child(sound_player)

func process_volume_changed() -> void:
	_music_player.adjust_volume_instant()
	_default_sound_player.adjust_volume_instant()
	for i in range(_sound_players_pool_size):
		_sound_players_pool[i].adjust_volume_instant()

func process_music(instant: bool, post_action: String, resource_name: String) -> void:
	_process_context(_music_player, instant, post_action, resource_name)

func process_sound(instant: bool, resource_name: String) -> void:
	var player = _pick_sound_player()
	_reset_player_pitch(player)
	_process_context(player, instant, "", resource_name)

func process_sound_random_pitch(resource_name: String, pitch_from: float, pitch_to: float) -> void:
	var random_pitch = randf_range(pitch_from, pitch_to)
	var player = _pick_sound_player()
	player.pitch_scale = random_pitch
	_process_context(player, true, "", resource_name)

func process_sound_looped(instant: bool, post_action: String, resource_name: String) -> void:
	if resource_name == null or resource_name == "":
		printerr("[CommonAudioProcessor] No looped sound resource name provided")
		return
	if resource_name == AudioConstants.ALL:
		if post_action == null or post_action == "":
			printerr("[CommonAudioProcessor] Post action should be provided for batch processing")
			return
		_process_post_action_for_all(post_action, instant)
		return
	if post_action != null and post_action != "":
		if not _looped_sound_players.has(resource_name):
			printerr("[CommonAudioProcessor] Looped sound is not processing: ", resource_name)
			return
		_process_post_action(_looped_sound_players[resource_name], post_action, instant)
		if post_action == AudioConstants.STOP:
			_looped_sound_players.erase(resource_name)
		return
	if _looped_sound_players.has(resource_name):
		printerr("[CommonAudioProcessor] Looped sound is already processing: ", resource_name)
		return
	var sound_player = _pick_sound_player()
	_reset_player_pitch(sound_player)
	_looped_sound_players[resource_name] = sound_player
	_process_resource(sound_player, resource_name, instant)

func _process_context(player: TypedAudioStreamPlayer, instant: bool, post_action: String, resource_name: String) -> void:
	if post_action != null and post_action != "":
		_process_post_action(player, post_action, instant)
		return
	if resource_name == null or resource_name == "":
		printerr("[CommonAudioProcessor] No resource name")
		return
	_process_resource(player, resource_name, instant)

func _process_post_action_for_all(post_action: String, instant: bool) -> void:
	for player in _looped_sound_players.values():
		_process_post_action(player, post_action, instant)
	if post_action == AudioConstants.STOP:
		_looped_sound_players.clear()

func _process_post_action(player: TypedAudioStreamPlayer, post_action: String, instant: bool) -> void:
	match post_action:
		AudioConstants.STOP:
			if instant:
				player.stop()
			else:
				player.adjust_volume_falling(_volume_change_seconds, func(): player.stop())
		AudioConstants.PAUSE:
			if instant:
				player.stream_paused = true
			else:
				player.adjust_volume_falling(_volume_change_seconds, func(): player.stream_paused = true)
		AudioConstants.RESUME:
			if instant:
				player.adjust_volume_instant()
			else:
				player.adjust_volume_rising(_volume_change_seconds)
			player.stream_paused = false
		_:
			printerr("[CommonAudioProcessor] Unknown post action: ", post_action)

func _process_resource(player: TypedAudioStreamPlayer, resource_name: String, instant: bool) -> void:
	if instant:
		player.adjust_volume_instant()
	else:
		player.adjust_volume_rising(_volume_change_seconds)
	player.stream = _get_cached_stream(resource_name)
	player.play()

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
