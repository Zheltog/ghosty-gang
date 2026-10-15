class_name TextBoxWithOptions

extends Control

const TWO_OPTIONS_GAP := 40.0
const OPTION_BUTTON_SIZE := Vector2(380, 140)

@export var window_name: String = ""
@export var printing_speed: float = INF
@export var printing_delay_multiplier: float = 4
@export var stack_lines: bool = true

@onready var _rect: TextureRect = $TextureRect
@onready var _board: DialogPhraseBoard = $TextureRect/PhraseBoard

var _option_holders: Dictionary = {}
var _is_shown: bool
var _are_options_shown: bool = true

func _ready() -> void:
	_rect.gui_input.connect(_on_texture_rect_gui_input)
	_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	_rect.add_to_group(Area2DUtils.MOUSE_BLOCK_GROUP)
	_assign_option_holder(1, "TextureRect/SingleOption")
	_assign_option_holder(2, "TextureRect/TwoOptions")
	_assign_option_holder(3, "TextureRect/ThreeOptions")
	_assign_option_holder(4, "TextureRect/FourOptions")
	_init_options()
	_hide_all_option_holders()
	_board.stack_lines = stack_lines
	_board.printing_speed = printing_speed
	_board.delay_multiplier = printing_delay_multiplier
	_board.setup(get_parent() as DialogWindowManager)
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
	return _board != null and _board.is_printing()

func has_options() -> bool:
	return _board != null and _board.has_options()

func interrupt_printing() -> void:
	if _board:
		_board.interrupt()

func skip_printing() -> void:
	if _board:
		_board.skip()

func show_line(text: String, options: Array, state: DialogState) -> void:
	if not _rect.is_visible():
		_rect.show()
	_hide_all_option_holders()
	_is_shown = true
	_board.show_line(text, options, state)

func hide_box_instantly() -> void:
	_hide_all_option_holders()
	_board.interrupt()
	_board.clear()
	_rect.hide()
	_is_shown = false

func show_reply_options(options: Array) -> void:
	_show_options(options)

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
		if options_size == 2:
			_layout_two_options(target_holder)

func _layout_two_options(holder: Control) -> void:
	if holder.get_child_count() < 2:
		return
	var first := holder.get_child(0) as Control
	var second := holder.get_child(1) as Control
	if first == null or second == null:
		return
	var width := _option_visual_size(first).x
	var total := width * 2.0 + TWO_OPTIONS_GAP
	var x0 := (_rect.size.x - total) * 0.5 - holder.position.x
	var y := first.position.y
	_place_option_origin(first, Vector2(x0, y))
	_place_option_origin(second, Vector2(x0 + width + TWO_OPTIONS_GAP, y))

func _option_visual_size(option: Control) -> Vector2:
	var visual := option.get_node_or_null("TextureButton") as Control
	if visual == null:
		return OPTION_BUTTON_SIZE
	if visual.size.x > 1.0 and visual.size.y > 1.0:
		return visual.size
	var button := visual as TextureButton
	if button != null and button.texture_normal != null:
		var tex_size := button.texture_normal.get_size()
		if tex_size.x > 1.0:
			return tex_size
	return OPTION_BUTTON_SIZE

func _place_option_origin(option: Control, origin: Vector2) -> void:
	option.anchor_left = 0.0
	option.anchor_top = 0.0
	option.anchor_right = 0.0
	option.anchor_bottom = 0.0
	option.position = origin
	option.size = Vector2.ZERO

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
