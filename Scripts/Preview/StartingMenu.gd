extends Control

@onready var _play_button: TextureButton = $PlayButton
@onready var _options_button: TextureButton = $OptionsButton

func _ready() -> void:
	SceneLoader.play_menu_music()
	_play_button.pressed.connect(_on_play_pressed)
	_options_button.pressed.connect(_on_options_pressed)
	if SaveManager.has_checkpoint():
		_add_continue_button()

func _on_play_pressed() -> void:
	SaveManager.reset_runtime()
	SceneLoader.change_scene(SceneLoader.SCENE.STARTING_CUTSCENE_1)

func _add_continue_button() -> void:
	var button := TextureButton.new()
	button.texture_normal = _play_button.texture_normal
	button.ignore_texture_size = true
	button.set_anchors_preset(Control.PRESET_CENTER)
	button.offset_left = -160.0
	button.offset_top = 80.0
	button.offset_right = 160.0
	button.offset_bottom = 160.0
	button.pressed.connect(_on_continue_pressed)
	add_child(button)
	var label := Label.new()
	label.text = "Continue"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 36)
	label.add_theme_color_override("font_color", Color.BLACK)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(label)
	_options_button.offset_top = 180.0
	_options_button.offset_bottom = 260.0

func _on_continue_pressed() -> void:
	SceneLoader.continue_saved_game()

func _on_options_pressed() -> void:
	pass
