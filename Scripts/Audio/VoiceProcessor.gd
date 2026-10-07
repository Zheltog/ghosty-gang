extends Node

const default_voice_sound_resource_name: String = "res://Assets/Audio/Voices/voice.wav"

var _voice_sound_resource_name: String

# speaker name -> { pitch: Vector2, sound: String }
var _speakers: Dictionary = {}

func _ready() -> void:
	AudioEventBus.play_speaker_voice_sound.connect(_play_speaker_voice_sound)

func set_voice_sound_resource_name(resource_name: String) -> void:
	_voice_sound_resource_name = resource_name

func register_speaker(speaker_name: String, pitch_from: float, pitch_to: float, voice_sound: String = "") -> void:
	_speakers[speaker_name] = {
		"pitch": Vector2(pitch_from, pitch_to),
		"sound": voice_sound.strip_edges(),
	}

func has_speaker(speaker_name: String) -> bool:
	return _speakers.has(speaker_name)

func _play_speaker_voice_sound(speaker_name: String) -> void:
	if speaker_name == null or speaker_name == "":
		printerr("[VoiceProcessor] No speaker name provided")
		return
	if not _speakers.has(speaker_name):
		printerr("[VoiceProcessor] Unknown speaker: ", speaker_name)
		return
	var speaker: Dictionary = _speakers[speaker_name]
	var resource_name: String = speaker["sound"]
	if resource_name.is_empty():
		resource_name = _voice_sound_resource_name \
			if _voice_sound_resource_name != null and _voice_sound_resource_name != "" \
			else default_voice_sound_resource_name
	var pitch: Vector2 = speaker["pitch"]
	var command = AudioSoundRandomPitchCommand.new()
	command.resource_name = resource_name
	command.pitch_from = pitch.x
	command.pitch_to = pitch.y
	CommonAudioProcessor.process_sound_random_pitch(command)
