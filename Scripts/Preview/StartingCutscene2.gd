extends "res://Scripts/Preview/DialogBackdrop.gd"

const ENGINE_SOUND := "res://Assets/Audio/Sounds/bus_engine.mp3"
const ENGINE_FADE_SECONDS := 2.0

func _ready() -> void:
	_fade_out_engine()
	super._ready()

func _fade_out_engine() -> void:
	if not CommonAudioProcessor.has_looped_sound(ENGINE_SOUND):
		return
	var command := AudioSoundLoopedCoomand.new()
	command.resource_name = ENGINE_SOUND
	command.post_action = AudioConstants.STOP
	command.instant = false
	command.adjustment_mode = TypedAudioStreamPlayer.AdjustmentMode.BY_TIME
	command.adjustment_value = ENGINE_FADE_SECONDS
	CommonAudioProcessor.process_sound_looped(command)
