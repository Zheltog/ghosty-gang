extends CanvasLayer

var _line : LineEdit
var _open := false

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	layer = 128
	_line = LineEdit.new()
	_line.visible = false
	_line.placeholder_text = "add SALT"
	add_child(_line)
	_line.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	_line.offset_bottom = 40
	_line.text_submitted.connect(_on_command_submitted)

func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_QUOTELEFT:
			_toggle()
			get_viewport().set_input_as_handled()
		elif _open and event.keycode == KEY_ESCAPE:
			_set_open(false)
			get_viewport().set_input_as_handled()

func _toggle() -> void:
	_set_open(not _open)

func _set_open(open : bool) -> void:
	_open = open
	_line.visible = _open
	if _open:
		_line.grab_focus()
	else:
		_line.release_focus()
		_line.clear()

func _on_command_submitted(text : String) -> void:
	var trimmed := text.strip_edges()
	if trimmed.is_empty():
		return
	_run_command(trimmed)
	_line.clear()

func _run_command(text : String) -> void:
	var parts := text.split(" ", false)
	if parts.is_empty():
		return
	var command := str(parts[0]).to_lower()
	if command == "add":
		if parts.size() < 2:
			printerr("Usage: add <item_name>")
			return
		var holder := get_tree().get_first_node_in_group("inventory_holder") as InventoryItemsHolder
		if holder == null:
			printerr("No InventoryItemsHolder in the scene")
			return
		var item := holder.add_item_by_name(str(parts[1]))
		if item != null:
			print("Added inventory item: ", str(parts[1]).to_upper())
		return
	printerr("Unknown command: ", text)
