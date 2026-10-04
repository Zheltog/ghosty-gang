class_name BoxOptionButton

extends Control

const SELECTED_MODULATE := Color(2.5, 2.5, 2.5, 1.0)
const SELECT_DURATION := 0.15

@export var id: int
const highlight_speed : float = 6.0
const min_font_size: int = 18

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _label: RichTextLabel = $TextureButton/RichTextLabel
@onready var _button: TextureButton = $TextureButton

var _manager: DialogWindowManager
var _base_font_size: int = 40

var in_focus : bool = false
var highlight : float = 0.0

func _process(delta: float) -> void:
	if in_focus:
		highlight += delta * highlight_speed
	else:
		highlight -= delta * highlight_speed
	highlight = clamp(highlight, 0.0, 1.0)
	_button.set_instance_shader_parameter("line_color", Color(highlight, highlight, highlight, 1.0))

func _ready() -> void:
	_button.pressed.connect(_on_texture_button_pressed)
	_button.mouse_entered.connect(_on_focus_entered)
	_button.focus_entered.connect(_on_focus_entered)
	_button.mouse_exited.connect(_on_focus_exited)
	_button.focus_exited.connect(_on_focus_exited)
	_label.scroll_active = false
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_base_font_size = _label.get_theme_font_size("normal_font_size")

func set_window_manager(manager: DialogWindowManager) -> void:
	_manager = manager

func set_text(text: String) -> void:
	_label.text = text
	_fit_font()

func _fit_font() -> void:
	var bounds := _label.size
	if bounds.x <= 1.0 or bounds.y <= 1.0:
		return
	var font := _label.get_theme_font("normal_font")
	var low := min_font_size
	var high := _base_font_size
	var best := low
	var wrap_flags := TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE
	while low <= high:
		var mid := (low + high) / 2
		var measured := font.get_multiline_string_size(
			_label.text,
			HORIZONTAL_ALIGNMENT_CENTER,
			bounds.x,
			mid,
			-1,
			wrap_flags
		)
		if measured.x <= bounds.x and measured.y <= bounds.y:
			best = mid
			low = mid + 1
		else:
			high = mid - 1
	_label.add_theme_font_size_override("normal_font_size", best)

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
