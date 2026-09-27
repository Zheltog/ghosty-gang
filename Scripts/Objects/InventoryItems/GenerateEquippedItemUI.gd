@tool
class_name GenerateEquippedItemUI
extends EditorScript

const JSON_PATH := "res://Files/_ObjectDescription/inventory_item.json"
const SPRITES_DIR := "res://Assets/Sprites/EquipedInventoryItems"
const GENERATOR_PATH := "res://Scripts/Objects/InventoryItems/EquippedItemUIGenerator.gd"
const SCENE_PATH := "res://Scenes/PointAndClick/InventoryUI/EquippedItemUI.tscn"
const SKIP_MARKER := "# SKIP GENERATION"


func _run() -> void:
	var items := _load_inventory_ids()
	if items.is_empty():
		printerr("GenerateEquippedItemUI: no inventory items")
		return
	_write_generator(items)
	EditorInterface.get_resource_filesystem().scan()
	print("GenerateEquippedItemUI: wrote ", GENERATOR_PATH)


func _load_inventory_ids() -> PackedStringArray:
	var file := FileAccess.open(JSON_PATH, FileAccess.READ)
	if file == null:
		return PackedStringArray()
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK or typeof(json.get_data()) != TYPE_DICTIONARY:
		return PackedStringArray()
	var ids: PackedStringArray = []
	for id in json.get_data():
		ids.append(str(id))
	return ids


func _write_generator(ids: PackedStringArray) -> void:
	var match_lines: PackedStringArray = []
	var setup_funcs: PackedStringArray = []
	for item_id in ids:
		var enum_name := item_id.to_upper()
		var fn := "_setup_%s" % item_id.to_lower()
		match_lines.append("\t\tInventoryItemGenerator.INVENTORY_ITEM.%s:" % enum_name)
		match_lines.append("\t\t\t%s(ui)" % fn)
		setup_funcs.append(_setup_func(fn, _collect_frames(item_id.to_lower())))
	var generated := "\n".join([
		"class_name EquippedItemUIGenerator",
		"extends Object",
		"",
		"const EQUIPPED_ITEM_UI = preload(\"%s\")" % SCENE_PATH,
		"",
		"static func generate(item : InventoryItemGenerator.INVENTORY_ITEM) -> EquippedItemUI:",
		"\tvar ui := EQUIPPED_ITEM_UI.instantiate() as EquippedItemUI",
		"\tmatch item:",
		"\n".join(match_lines),
		"\treturn ui",
		"",
		"\n".join(setup_funcs),
	]) + "\n"
	_write_generated(generated)


func _setup_func(fn: String, actions: Dictionary) -> String:
	var lines: PackedStringArray = [
		"static func %s(ui: EquippedItemUI) -> void:" % fn,
		"\tvar frames := SpriteFrames.new()",
	]
	var names: Array = actions.keys()
	names.sort()
	if not names.has("default"):
		names.insert(0, "default")
	else:
		names.erase("default")
		names.insert(0, "default")
	for action in names:
		lines.append("\tframes.add_animation(\"%s\")" % action)
		var frames: Array = actions.get(action, [])
		frames.sort_custom(func(a, b): return a.idx < b.idx)
		for frame in frames:
			lines.append("\tframes.add_frame(\"%s\", preload(\"%s\"))" % [action, frame.path])
	lines.append("\tui.sprite_frames = frames")
	lines.append("\tui.play(\"default\")")
	return "\n".join(lines)


func _collect_frames(item_name: String) -> Dictionary:
	var actions := {}
	var dir := DirAccess.open(SPRITES_DIR)
	if dir == null:
		return actions
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and not file_name.ends_with(".import"):
			var parsed := _parse_sprite(item_name, file_name)
			if not parsed.is_empty():
				if not actions.has(parsed.action):
					actions[parsed.action] = []
				actions[parsed.action].append({
					"idx": parsed.idx,
					"path": SPRITES_DIR.path_join(file_name),
				})
		file_name = dir.get_next()
	return actions


func _parse_sprite(item_name: String, file_name: String) -> Dictionary:
	var stem := file_name.get_basename()
	if stem == item_name:
		return {"action": "default", "idx": 0}
	var prefix := item_name + "_"
	if not stem.begins_with(prefix):
		return {}
	var rest := stem.substr(prefix.length())
	var sep := rest.rfind("_")
	if sep <= 0:
		return {}
	var idx_str := rest.substr(sep + 1)
	if not idx_str.is_valid_int():
		return {}
	return {"action": rest.substr(0, sep), "idx": int(idx_str)}


func _write_generated(generated: String) -> void:
	var contents := generated.rstrip("\n") + "\n\n" + SKIP_MARKER + "\n"
	var file := FileAccess.open(GENERATOR_PATH, FileAccess.WRITE)
	if file == null:
		printerr("GenerateEquippedItemUI: could not write ", GENERATOR_PATH)
		return
	file.store_string(contents)
