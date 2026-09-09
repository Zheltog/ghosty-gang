extends Control

@onready var _play_button: TextureButton = $PlayButton
@onready var _options_button: TextureButton = $OptionsButton

func _ready() -> void:
	_play_button.pressed.connect(_on_play_pressed)
	_options_button.pressed.connect(_on_options_pressed)

func _on_play_pressed() -> void:
	SceneLoader.change_scene(SceneLoader.SCENE.STARTING_CUTSCENE_1)

func _on_options_pressed() -> void:
	pass
