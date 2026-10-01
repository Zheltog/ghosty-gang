class_name BoxOptionButton

extends Control

const SELECTED_MODULATE := Color(2.5, 2.5, 2.5, 1.0)
const SELECT_DURATION := 0.15

@export var id: int

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _label: RichTextLabel = $TextureButton/RichTextLabel
@onready var _button: TextureButton = $TextureButton

var _manager: DialogWindowManager

var in_focus : bool = false
var highlight : float = 0.0

func _process(delta: float) -> void:
	if in_focus:
		highlight += delta * 3.0
	else:
		highlight -= delta * 3.0
	highlight = clamp(highlight, 0.0, 1.0)
	_button.set_instance_shader_parameter("line_color", Color(highlight, highlight, highlight, 1.0))

func _ready() -> void:
	_button.pressed.connect(_on_texture_button_pressed)
	_button.mouse_entered.connect(_on_focus_entered)
	_button.focus_entered.connect(_on_focus_entered)
	_button.mouse_exited.connect(_on_focus_exited)
	_button.focus_exited.connect(_on_focus_exited)

func set_window_manager(manager: DialogWindowManager) -> void:
	_manager = manager

func set_text(text: String) -> void:
	_label.text = text

func reset_visual() -> void:
	(_button.material as ShaderMaterial).set_shader_parameter("line_color", Color.BLACK)
	show()
	_button.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_texture_button_pressed() -> void:
	if _manager:
		_manager.option_pressed(id, self)

func _on_focus_entered() -> void:
	in_focus = true

func _on_focus_exited() -> void:
	in_focus = false

func display_selected() -> void:
	_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_animation_player.play("selected")
	await _animation_player.animation_finished
