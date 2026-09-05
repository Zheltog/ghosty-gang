class_name TextBoxWithOptions

extends Control

const max_printing_id: int = 100

@export var appear_anim_name: String = "appear"
@export var disappear_anim_name: String = "disappear"
@export var printing_speed: float = 60
@export var printing_delay_multiplier: float = 4
@export var controller: DialogController

@onready var _label: RichTextLabel = $TextureRect/RichTextLabel
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _rect: TextureRect = $TextureRect

var _option_holders: Dictionary = {}
var _saved_text: String
var _saved_options: Array
var _is_shown: bool
var _are_options_shown: bool = true
var _full_text: String
var _is_printing: bool
var _seconds_before_next_symbol: float = -1
var _showing_requested: bool
var _saved_printing_id: int = 0

func _ready() -> void:
	_anim_player.animation_finished.connect(_on_animation_finished)
	_rect.gui_input.connect(_on_texture_rect_gui_input)
	_label.text = ""
	_option_holders[1] = $TextureRect/SingleOption
	_option_holders[2] = $TextureRect/TwoOptions
	_option_holders[3] = $TextureRect/ThreeOptions
	_init_options()
	_hide_all_option_holders()
	_rect.hide()

func _init_options() -> void:
	for holder_value in _option_holders.values():
		for option_button in holder_value.get_children():
			(option_button as BoxOptionButton).set_dialog_controller(controller)

func _hide_all_option_holders() -> void:
	if not _are_options_shown:
		return
	for holder_value in _option_holders.values():
		if holder_value.is_visible():
			holder_value.hide()
	_are_options_shown = false

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		controller.try_next()

func is_shown() -> bool:
	return _is_shown

# TODO: impl animations
func _show_box(text: String, options: Array) -> void:
	_hide_all_option_holders()
	if _rect.is_visible():
		if not _showing_requested:
			_do_show(text, options)
		else:
			_saved_text = text
			_saved_options = options
	else:
		_showing_requested = true
		_rect.show()
		_saved_text = text
		_saved_options = options
		_anim_player.play(appear_anim_name)

func show_box_instantly(text: String, options: Array) -> void:
	if not _rect.is_visible():
		_rect.show()
	_hide_all_option_holders()
	_do_show(text, options)

# TODO: impl animations
func _hide_box() -> void:
	# TODO: smooth animation too?
	_hide_all_option_holders()
	_anim_player.play(disappear_anim_name)

func hide_box_instantly() -> void:
	_hide_all_option_holders()
	_do_hide()

func _do_show(text: String, options: Array[InkChoice]) -> void:
	_label.text = ""
	if _seconds_before_next_symbol < 0:
		_seconds_before_next_symbol = 1 / printing_speed
	_is_printing = true
	_is_shown = true
	await _print_text(text)
	_show_options(options)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == appear_anim_name:
		_showing_requested = false
		_do_show(_saved_text, _saved_options)
	elif anim_name == disappear_anim_name:
		_do_hide()

func _do_hide() -> void:
	_rect.hide()
	_is_shown = false

func _print_text(text: String) -> void:
	_full_text = text
	var previous_char = ''
	var printing_id = _get_next_printing_id()
	_saved_printing_id = printing_id
	for char in _full_text:
		await get_tree().create_timer(_get_char_delay(previous_char, char)).timeout
		# TODO: should be able to print full text instantly?
		if not _is_printing or _saved_printing_id != printing_id:
			return
		if !_is_space(char) && !_is_punctiation(char):
			_play_print_sound()
		_label.text += char
		previous_char = char
	_is_printing = false

func _show_options(options: Array[InkChoice]):
	_are_options_shown = true
	var options_size = options.size()
	var target_holder
	for holder_key in _option_holders.keys():
		if holder_key == options_size and not _option_holders[holder_key].is_visible():
			target_holder = _option_holders[holder_key]
			target_holder.show()
	var i = 0
	if target_holder != null:
		for option_button in target_holder.get_children():
			var option = options[i]
			(option_button as BoxOptionButton).set_text(option.GetText())
			i += 1

func _get_char_delay(previous_char, next_char) -> float:
	if (_is_punctiation(previous_char) and _is_space(next_char)) or next_char == '\n':
		return _seconds_before_next_symbol * printing_delay_multiplier
	else:
		return _seconds_before_next_symbol;

func _is_punctiation(char) -> bool:
	return ".,?!:;-()\"\"".contains(char)
	
func _is_space(char) -> bool:
	return " \n\t".contains(char)
	
func _play_print_sound() -> void:
	# TODO: impl
	pass

func _get_next_printing_id() -> int:
	return 1 if _saved_printing_id == max_printing_id else _saved_printing_id + 1
