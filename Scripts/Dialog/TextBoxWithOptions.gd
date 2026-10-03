class_name TextBoxWithOptions

extends Control

const OPTIONS_MARKER := "%%"
const max_printing_id: int = 100

signal line_finished

@export var window_name: String = ""
@export var appear_anim_name: String = "appear"
@export var disappear_anim_name: String = "disappear"
@export var printing_speed: float = INF
@export var printing_delay_multiplier: float = 4
@export var controller: DialogController

@onready var _label: RichTextLabel = $TextureRect/RichTextLabel
@onready var _character_name: Label = $TextureRect/CharacterName
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
var _current_speaker_name: String
var _pending_options: Array = []
var _options_at: int = -1
var _options_revealed: bool = false
var _instant_line: bool = false

func _ready() -> void:
	_anim_player.animation_finished.connect(_on_animation_finished)
	_rect.gui_input.connect(_on_texture_rect_gui_input)
	_label.text = ""
	_assign_option_holder(1, "TextureRect/SingleOption")
	_assign_option_holder(2, "TextureRect/TwoOptions")
	_assign_option_holder(3, "TextureRect/ThreeOptions")
	_init_options()
	_hide_all_option_holders()
	_rect.hide()

## Ink name for this window. Uses `window_name` when set, otherwise the node name.
func resolved_window_name() -> String:
	var raw := window_name.strip_edges()
	if raw.is_empty():
		raw = String(name)
	return DialogState.normalize_window_name(raw)

func _assign_option_holder(count: int, path: String) -> void:
	if has_node(path):
		_option_holders[count] = get_node(path)

func _init_options() -> void:
	var manager := get_parent() as DialogWindowManager
	for holder_value in _option_holders.values():
		for option_button in holder_value.get_children():
			(option_button as BoxOptionButton).set_window_manager(manager)

func _hide_all_option_holders() -> void:
	if not _are_options_shown:
		return
	for holder_value in _option_holders.values():
		if holder_value.is_visible():
			holder_value.hide()
	_are_options_shown = false

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var manager := get_parent() as DialogWindowManager
		if manager:
			manager.handle_click()

func is_shown() -> bool:
	return _is_shown

func is_printing() -> bool:
	return _is_printing

func has_options() -> bool:
	return not _pending_options.is_empty()

func interrupt_printing() -> void:
	_is_printing = false

func skip_printing() -> void:
	if not _is_printing:
		return
	_label.text = _full_text
	_is_printing = false
	_try_reveal_options()
	line_finished.emit()

# TODO: impl animations
func _show_box(text: String, options: Array, speaker_name: String = "", character_tag: String = "") -> void:
	_current_speaker_name = speaker_name
	_set_character_name(character_tag)
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

func show_box_instantly(text: String, options: Array, speaker_name: String = "", instant: bool = false, character_tag: String = "") -> void:
	_instant_line = instant
	_current_speaker_name = speaker_name
	_set_character_name(character_tag)
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

func _do_show(text: String, options: Array) -> void:
	_label.text = ""
	if _instant_line or printing_speed <= 0.0 or not is_finite(printing_speed):
		_seconds_before_next_symbol = 0.0
	else:
		_seconds_before_next_symbol = 1.0 / printing_speed
	_is_printing = true
	_is_shown = true
	_pending_options = options
	var marker_at := text.find(OPTIONS_MARKER)
	_options_at = marker_at
	_options_revealed = false
	var display_text := text.replace(OPTIONS_MARKER, "")
	var finished := await _print_text(display_text)
	if not finished:
		return
	_try_reveal_options()
	line_finished.emit()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == appear_anim_name:
		_showing_requested = false
		_do_show(_saved_text, _saved_options)
	elif anim_name == disappear_anim_name:
		_do_hide()

func _do_hide() -> void:
	_rect.hide()
	_set_character_name("")
	_is_shown = false

func _set_character_name(character_tag: String) -> void:
	var shown := CharacterNames.display_name(character_tag)
	_character_name.text = shown
	_character_name.visible = not shown.is_empty()

func _print_text(text: String) -> bool:
	_full_text = text
	var previous_char = ''
	var printing_id = _get_next_printing_id()
	_saved_printing_id = printing_id
	if _seconds_before_next_symbol <= 0.0:
		_label.text = _full_text
		_is_printing = false
		_play_voice_blip()
		_try_reveal_options()
		return true
	_try_reveal_options()
	for char in _full_text:
		await get_tree().create_timer(_get_char_delay(previous_char, char)).timeout
		if not _is_printing or _saved_printing_id != printing_id:
			return false
		if !_is_space(char) && !_is_punctiation(char):
			_play_voice_blip()
		_label.text += char
		previous_char = char
		_try_reveal_options()
	_is_printing = false
	return true

func _try_reveal_options() -> void:
	if _options_revealed:
		return
	if _options_at >= 0 and _label.text.length() < _options_at:
		return
	if _options_at < 0 and _is_printing:
		return
	_options_revealed = true
	_show_options(_pending_options)
	controller.start_option_timeout()

func _show_options(options: Array):
	_are_options_shown = true
	var options_size = options.size()
	var target_holder
	for holder_key in _option_holders.keys():
		if holder_key == options_size and not _option_holders[holder_key].is_visible():
			target_holder = _option_holders[holder_key]
			for option_button in target_holder.get_children():
				(option_button as BoxOptionButton).reset_visual()
			target_holder.show()
	var i = 0
	if target_holder != null:
		for option_button in target_holder.get_children():
			var option = options[i]
			var button := option_button as BoxOptionButton
			button.set_text(option.GetText())
			button.id = option.GetIndex()
			i += 1

func hide_other_options(selected: BoxOptionButton) -> void:
	for holder in _option_holders.values():
		if not holder.visible:
			continue
		for child in holder.get_children():
			if selected != null and child == selected:
				continue
			child.hide()

func find_option_button(choice_id: int) -> BoxOptionButton:
	for holder in _option_holders.values():
		if not holder.visible:
			continue
		for child in holder.get_children():
			var button := child as BoxOptionButton
			if button and button.id == choice_id:
				return button
	return null

func _get_char_delay(previous_char, next_char) -> float:
	if (_is_punctiation(previous_char) and _is_space(next_char)) or next_char == '\n':
		return _seconds_before_next_symbol * printing_delay_multiplier
	else:
		return _seconds_before_next_symbol;

func _play_voice_blip() -> void:
	if _current_speaker_name.is_empty():
		return
	AudioEventBus.play_speaker_voice_sound.emit(_current_speaker_name)

func _is_punctiation(char) -> bool:
	return ".,?!:;-()\"\"".contains(char)
	
func _is_space(char) -> bool:
	return " \n\t".contains(char)

func _get_next_printing_id() -> int:
	return 1 if _saved_printing_id == max_printing_id else _saved_printing_id + 1
