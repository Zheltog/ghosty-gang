extends "res://Scripts/Preview/DialogBackdrop.gd"

const ENGINE_SOUND := "res://Assets/Audio/Sounds/bus_engine.mp3"
const ENGINE_RISE_SECONDS := 10.0

func _ready() -> void:
	_play_engine()
	super._ready()

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
