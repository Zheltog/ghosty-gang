class_name AudioSettings

extends CanvasLayer

@onready var _reset_button: Button = $ResetButton
@onready var _ok_button: Button = $OkButton
@onready var _music_percent_label: Label = $MusicPercentLabel
@onready var _sounds_total_percent_label: Label = $SoundsTotalPercentLabel
@onready var _voices_percent_label: Label = $SoundsVoicesPercentLabel
@onready var _music_slider: HSlider = $MusicHSlider
@onready var _sounds_total_slider: HSlider = $SoundsTotalHSlider
@onready var _voices_slider: HSlider = $SoundsVoicesHSlider

func _ready() -> void:
	_ok_button.pressed.connect(_process_ok)
	_reset_button.pressed.connect(_process_reset)
	_music_slider.value_changed.connect(_process_music_slider_update)
	_sounds_total_slider.value_changed.connect(_process_sound_total_slider_update)
	_voices_slider.value_changed.connect(_process_voice_slider_update)
	_setup_sliders_and_labels()
	# test
	CommonAudioProcessor.tag_volumes["TEST"] = 50
	var command = AudioMusicCommand.new()
	command.resource_name = "res://Assets/Audio/shagom_marsh.wav"
	command.tag = "TEST"
	CommonAudioProcessor.process_music(command)

func _process_ok() -> void:
	print("OK")

func _process_reset() -> void:
	CommonAudioProcessor.music_volume = CommonAudioProcessor.default_music_volume
	CommonAudioProcessor.sound_volume = CommonAudioProcessor.default_sound_volume
	CommonAudioProcessor.tag_volumes[AudioConstants.VOICE] = 100
	CommonAudioProcessor.process_music_volume_changed()
	CommonAudioProcessor.process_sound_volume_changed()
	_setup_sliders_and_labels()

func _process_music_slider_update(value: float) -> void:
	CommonAudioProcessor.music_volume = value as int
	CommonAudioProcessor.process_music_volume_changed()
	_update_music_percent_label()

func _process_sound_total_slider_update(value: float) -> void:
	CommonAudioProcessor.sound_volume = value as int
	CommonAudioProcessor.process_sound_volume_changed()
	_update_sounds_total_percent_label()

func _process_voice_slider_update(value: float) -> void:
	CommonAudioProcessor.tag_volumes[AudioConstants.VOICE] = value as int
	# no need to process changed volume - new value will be applied for next sound
	_update_voice_percent_label()

func _setup_sliders_and_labels() -> void:
	_music_slider.value = CommonAudioProcessor.music_volume
	_sounds_total_slider.value = CommonAudioProcessor.sound_volume
	_voices_slider.value = CommonAudioProcessor.tag_volumes.get(AudioConstants.VOICE, 100)
	_update_percent_labels()

func _update_percent_labels() -> void:
	_update_music_percent_label()
	_update_sounds_total_percent_label()
	_update_voice_percent_label()

func _update_music_percent_label() -> void:
	_music_percent_label.text = str(_music_slider.value as int, "%")

func _update_sounds_total_percent_label() -> void:
	_sounds_total_percent_label.text = str(_sounds_total_slider.value as int, "%")

func _update_voice_percent_label() -> void:
	_voices_percent_label.text = str(_voices_slider.value as int, "%")
