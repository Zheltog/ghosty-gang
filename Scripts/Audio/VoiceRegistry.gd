extends Node

const _default_pitch_from := 0.75
const _default_pitch_to := 1.25
const _typewriter := "res://Assets/Audio/Voices/Typewriter.mp3"

func _ready() -> void:
	_register("dossier", _typewriter, 0.95, 1.05)
	_register("detective")
	_register("driver")
	_register("scout")
	_register("landlady")
	_register("cashier")
	_register("engineer")

func _register(speaker_name: String, voice_sound: String = "", pitch_from: float = _default_pitch_from, pitch_to: float = _default_pitch_to) -> void:
	VoiceProcessor.register_speaker(speaker_name, pitch_from, pitch_to, voice_sound)
