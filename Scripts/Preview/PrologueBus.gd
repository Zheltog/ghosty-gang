extends "res://Scripts/Preview/DialogBackdrop.gd"

const ENGINE_SOUND := "res://Assets/Audio/Sounds/bus_engine.mp3"
const ENGINE_RISE_SECONDS := 10.0
const STORY_DELAY_SECONDS := 2.0
const ENGINE_FADE_SECONDS := 2.0
const BUS_STOP_SOUND := "res://Assets/Audio/Sounds/bus_arrival.mp3"
const ARRIVAL_STORY := "res://Files/SceneDialogs/Ink/day1_bus_arrival.ink"

func _ready() -> void:
	_dialog.story_finished.connect(_on_story_finished)
	if story_path.is_empty():
		printerr("PrologueBus: story_path is empty")
		return
	_play_engine()
	await get_tree().create_timer(STORY_DELAY_SECONDS).timeout
	if not is_inside_tree():
		return
	_dialog.start_story(story_path)

func _on_story_finished(story_name: String) -> void:
	if story_name == "bus":
		_play_bus_stop()
		_dialog.start_story(ARRIVAL_STORY)
		return
	if story_name == "bus_arrival":
		_fade_out_engine()
		await fade_to_black()
		if not is_inside_tree():
			return
		await get_tree().create_timer(0.6).timeout
		if not is_inside_tree():
			return
	super._on_story_finished(story_name)

func _play_bus_stop() -> void:
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = BUS_STOP_SOUND
	CommonAudioProcessor.process_sound(command)

func _play_engine() -> void:
	var stream := load(ENGINE_SOUND)
	if stream is AudioStreamMP3:
		stream.loop = true
	var command := AudioSoundLoopedCoomand.new()
	command.instant = false
	command.resource_name = ENGINE_SOUND
	command.adjustment_mode = TypedAudioStreamPlayer.AdjustmentMode.BY_TIME
	command.adjustment_value = ENGINE_RISE_SECONDS
	command.relative_volume = 100
	CommonAudioProcessor.process_sound_looped(command)

func _fade_out_engine() -> void:
	var command := AudioSoundLoopedCoomand.new()
	command.resource_name = ENGINE_SOUND
	command.post_action = AudioConstants.STOP
	command.instant = false
	command.adjustment_mode = TypedAudioStreamPlayer.AdjustmentMode.BY_TIME
	command.adjustment_value = ENGINE_FADE_SECONDS
	CommonAudioProcessor.process_sound_looped(command)
