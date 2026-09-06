class_name BoxOptionButton

extends Control

@export var id: int

@onready var _label: RichTextLabel = $TextureButton/RichTextLabel

var _controller: DialogController

func _ready() -> void:
	$TextureButton.pressed.connect(_on_texture_button_pressed)

func set_dialog_controller(controller: DialogController):
	_controller = controller

func set_text(text: String) -> void:
	_label.text = text

func _on_texture_button_pressed() -> void:
	_controller.process_option_selected(id)
