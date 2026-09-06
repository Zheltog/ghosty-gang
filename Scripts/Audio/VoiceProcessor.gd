extends Node

const default_voice_sound_resource_name: String = "res://Assets/Audio/voice.wav"

var _voice_sound_resource_name: String

# String -> Vector2
var _pitches: Dictionary = {}

func _ready() -> void:
	AudioEventBus.play_speaker_voice_sound.connect(_play_speaker_voice_sound)

func set_voice_sound_resource_name(resource_name: String) -> void:
	_voice_sound_resource_name = resource_name

func register_speaker(speaker_name: String, pitch_from: float, pitch_to: float) -> void:
	_pitches[speaker_name] = Vector2(pitch_from, pitch_to)

func _play_speaker_voice_sound(speaker_name: String) -> void:
	if speaker_name == null or speaker_name == "":
		printerr("[VoiceProcessor] No speaker name provided")
		return
	if not _pitches.has(speaker_name):
		printerr("[VoiceProcessor] Unknown speaker: ", speaker_name)
		return
	var resource_name = _voice_sound_resource_name \
		if _voice_sound_resource_name != null and _voice_sound_resource_name != "" \
		else default_voice_sound_resource_name
	var pitch = _pitches[speaker_name]
	CommonAudioProcessor.process_sound_random_pitch(resource_name, pitch.x, pitch.y)
