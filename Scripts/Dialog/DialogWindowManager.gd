class_name DialogWindowManager

extends Node

const default_window_name := "default"
const hold_skip_start_delay := 0.18
const hold_skip_interval := 0.06

var _controller: DialogController
var _state: DialogState
var _windows: Dictionary = {}
var _default_box: TextBoxWithOptions
var _active_box: TextBoxWithOptions
var _current_window: TextBoxWithOptions
var _delay_id: int = 0
var _hold_skip_wait: float = 0.0

func setup(controller: DialogController, state: DialogState) -> void:
	_controller = controller
	_state = state

func _ready() -> void:
	_collect_windows(self)
	if _default_box == null and not _windows.is_empty():
		_default_box = _windows.values()[0]
		printerr("DialogWindowManager: no '%s' dialog window, using '%s'" % [default_window_name, _default_box.resolved_window_name()])
	if _windows.is_empty():
		printerr("DialogWindowManager: no dialog windows")
	_active_box = _default_box
	_current_window = _default_box

func display(text: String, choices: Array) -> void:
	_cancel_delay()
	if _state != null and not _state.window_name.is_empty():
		_open(_state.window_name)
		_current_window = _active_box
	if _state != null and _state.thought:
		_open(DialogState.thought_window)
	elif _state != null and _state.response:
		_open(DialogState.player_phrase_window)
	elif _current_window != null and _active_box != _current_window:
		_open(_current_window.resolved_window_name())
	if _active_box == null:
		printerr("DialogWindowManager: no dialog window available")
		return
	var instant := _state != null and _state.instant
	var speaker := "" if _state == null else _state.speaker_name
	var character_tag := ""
	if _state != null and not _state.thought:
		character_tag = _state.character_name
	_active_box.show_box_instantly(text, choices, speaker, instant, character_tag)

func reset() -> void:
	_cancel_delay()
	if _active_box != null and _active_box != _default_box:
		_active_box.interrupt_printing()
		_active_box.hide_box_instantly()
	_active_box = _default_box
	_current_window = _default_box

func close() -> void:
	_cancel_delay()
	for box in _windows.values():
		box.interrupt_printing()
		box.hide_box_instantly()

func _unhandled_input(event: InputEvent) -> void:
	if not _can_skip_input():
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if DialogController.is_world_locked():
			handle_click()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		_mark_input_handled()
		_hold_skip_wait = hold_skip_start_delay
		handle_click(true)

func _process(delta: float) -> void:
	if not _can_skip_input() or not Input.is_physical_key_pressed(KEY_SPACE):
		_hold_skip_wait = 0.0
		return
	_hold_skip_wait -= delta
	if _hold_skip_wait > 0.0:
		return
	handle_click(true)
	_hold_skip_wait = hold_skip_interval

func _mark_input_handled() -> void:
	var viewport := get_viewport()
	if viewport:
		viewport.set_input_as_handled()

func _can_skip_input() -> bool:
	return DialogController.is_dialog_active() and _active_box != null and _active_box.is_shown()

func handle_click(force := false) -> void:
	if _active_box == null or _state == null or _controller == null:
		return
	if _active_box.is_printing():
		if not force and not _state.skippable:
			return
		_active_box.skip_printing()
		if not force or _state.skippable:
			return
	if _active_box.has_options() or _state.react_wait:
		return
	if not force and not _state.skippable:
		return
	_controller.proceed()

func option_pressed(id: int, box: BoxOptionButton) -> void:
	if _controller:
		_controller.process_option_selected(id, box)

func confirm_option(box: BoxOptionButton) -> void:
	if _active_box:
		_active_box.hide_other_options(box)
		_active_box.interrupt_printing()
	if box:
		await box.display_selected()

func find_option_button(choice_id: int) -> BoxOptionButton:
	if _active_box == null:
		return null
	return _active_box.find_option_button(choice_id)

func _collect_windows(node: Node) -> void:
	for child in node.get_children():
		if child is TextBoxWithOptions:
			_register_window(child)
			continue
		_collect_windows(child)

func _register_window(box: TextBoxWithOptions) -> void:
	var window_name := box.resolved_window_name()
	if window_name.is_empty():
		printerr("DialogWindowManager: dialog window '%s' has an empty name" % box.name)
		return
	if _windows.has(window_name):
		printerr("DialogWindowManager: duplicate dialog window '%s'" % window_name)
		return
	_windows[window_name] = box
	if window_name == default_window_name:
		_default_box = box
	if not box.line_finished.is_connected(_on_line_finished):
		box.line_finished.connect(_on_line_finished.bind(box))

func _open(window_name: String) -> void:
	var next_box: TextBoxWithOptions = _windows.get(window_name)
	if next_box == null:
		next_box = _default_box
	if next_box == null:
		return
	if _active_box != null and _active_box != next_box:
		_active_box.interrupt_printing()
		_active_box.hide_box_instantly()
	_active_box = next_box

func _on_line_finished(box: TextBoxWithOptions) -> void:
	if box != _active_box or _state == null or _controller == null or _state.skippable:
		return
	if box.has_options() or _state.react_wait:
		return
	_delay_id += 1
	var wait_id := _delay_id
	await get_tree().create_timer(_controller.response_continue_delay).timeout
	if wait_id != _delay_id:
		return
	_controller.proceed()

func _cancel_delay() -> void:
	_delay_id += 1
