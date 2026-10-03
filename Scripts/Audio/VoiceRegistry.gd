extends Node

const _default_pitch_from := 0.75
const _default_pitch_to := 1.25
const _typewriter := "res://Assets/Audio/Voices/Typewriter.mp3"
const _default: String = "res://Assets/Audio/Voices/default_voice.wav"

func _ready() -> void:
	_register("dossier", _typewriter, 0.95, 1.05)
	_register("detective", _default, 0.9, 1.10)
	_register("driver", _default, 0.9, 1.10)
	_register("scout", _default, 1.9, 2.10)
	_register("landlady", _default, 1.2, 1.3)
	_register("cashier", _default, 1.2, 1.4)
	_register("engineer", _default, 1.1, 1.5)

func _register(speaker_name: String, voice_sound: String = "", pitch_from: float = _default_pitch_from, pitch_to: float = _default_pitch_to) -> void:
	VoiceProcessor.register_speaker(speaker_name, pitch_from, pitch_to, voice_sound)
