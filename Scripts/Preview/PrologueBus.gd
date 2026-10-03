extends "res://Scripts/Preview/DialogBackdrop.gd"

const ENGINE_SOUND := "res://Assets/Audio/Sounds/bus_engine.mp3"
const ENGINE_RISE_SECONDS := 10.0
const BUS_STOP_SOUND := "res://Assets/Audio/Sounds/bus_arrival.mp3"
const ARRIVAL_STORY := "res://Files/SceneDialogs/Ink/day1_bus_arrival.ink"

func _ready() -> void:
	_dialog.story_finished.connect(_on_story_finished)
	if story_path.is_empty():
		printerr("PrologueBus: story_path is empty")
		return
	_play_engine()
	await get_tree().create_timer(ENGINE_RISE_SECONDS).timeout
	if not is_inside_tree():
		return
	_dialog.start_story(story_path)

func _on_story_finished(story_name: String) -> void:
	if story_name == "bus":
		await _play_bus_stop()
		if not is_inside_tree():
			return
		_dialog.start_story(ARRIVAL_STORY)
		return
	super._on_story_finished(story_name)

func _play_bus_stop() -> void:
	var stream := load(BUS_STOP_SOUND) as AudioStream
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = BUS_STOP_SOUND
	CommonAudioProcessor.process_sound(command)
	var length := stream.get_length() if stream else 0.0
	if length > 0.0:
		await get_tree().create_timer(length).timeout

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
