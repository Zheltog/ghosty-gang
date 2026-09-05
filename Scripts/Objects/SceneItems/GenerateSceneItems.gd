@tool
class_name GenerateSceneItems
extends EditorScript

const JSON_PATH := "res://Files/_ObjectDescription/scene_items.json"
const GEN_DIR := "res://Scripts/Objects/SceneItems/Gen"
const GENERATOR_PATH := "res://Scripts/Objects/SceneItems/SceneItemGenerator.gd"
const SKIP_MARKER := "# SKIP GENERATION"

func _run() -> void:
	var items := _load_scene_items()
	if items.is_empty():
		printerr("GenerateSceneItems: no scene items loaded from ", JSON_PATH)
		return

	var abs_gen_dir := ProjectSettings.globalize_path(GEN_DIR)
	DirAccess.make_dir_recursive_absolute(abs_gen_dir)

	var ids: PackedStringArray = []
	for id in items:
		var item_id := str(id)
		var data: Variant = items[id]
		if typeof(data) != TYPE_DICTIONARY:
			printerr("GenerateSceneItems: skipping '", item_id, "' - expected a Dictionary")
			continue
		ids.append(item_id)
		_write_item_script(item_id, data)

	if ids.is_empty():
		printerr("GenerateSceneItems: no valid scene items to generate")
		return

	_write_generator_script(ids)
	EditorInterface.get_resource_filesystem().scan()
	print("GenerateSceneItems: generated ", ids.size(), " scene item script(s)")


func _load_scene_items() -> Dictionary:
	var file := FileAccess.open(JSON_PATH, FileAccess.READ)
	if file == null:
		printerr("GenerateSceneItems: could not open ", JSON_PATH, " (", FileAccess.get_open_error(), ")")
		return {}
	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())
	if parse_result != OK:
		printerr("GenerateSceneItems: JSON parse error: ", json.get_error_message(), " at line ", json.get_error_line())
		return {}
	var data: Variant = json.get_data()
	if typeof(data) != TYPE_DICTIONARY:
		printerr("GenerateSceneItems: root of ", JSON_PATH, " must be a Dictionary")
		return {}
	return data


func _write_item_script(item_id: String, data: Dictionary) -> void:
	var class_name_str := "SceneItem" + _to_pascal_case(item_id)
	var path := GEN_DIR.path_join(class_name_str + ".gd")
	var lines: PackedStringArray = [
		"class_name %s" % class_name_str,
		"extends SceneItemBase",
		"",
		"func _init() -> void:",
	]
	lines.append_array(_init_assignments(item_id, data))
	_write_generated(path, "\n".join(lines) + "\n")


func _init_assignments(item_id: String, data: Dictionary) -> PackedStringArray:
	var lines: PackedStringArray = [
		"\titem = SceneItemGenerator.SCENE_ITEM.%s" % _to_enum_name(item_id),
	]
	if data.has("pickable"):
		lines.append("\tpickable = %s" % _gdscript_literal(data["pickable"]))
	if data.has("equiped_immediately"):
		lines.append("\tequiped_immediately = %s" % _gdscript_literal(data["equiped_immediately"]))
	if data.has("inventory_item") and str(data["inventory_item"]) != "":
		lines.append("\tinventory_item = InventoryItemGenerator.INVENTORY_ITEM.%s" % _to_enum_name(str(data["inventory_item"])))
	if data.has("ink_story_view") and str(data["ink_story_view"]) != "":
		lines.append("\tink_story_view = %s" % _gdscript_literal(data["ink_story_view"]))
	return lines


func _write_generator_script(ids: PackedStringArray) -> void:
	var enum_lines: PackedStringArray = []
	var match_lines: PackedStringArray = []
	for i in ids.size():
		var enum_name := _to_enum_name(ids[i])
		var class_name_str := "SceneItem" + _to_pascal_case(ids[i])
		var comma := "," if i < ids.size() - 1 else ""
		enum_lines.append("\t%s%s" % [enum_name, comma])
		match_lines.append("\t\tSCENE_ITEM.%s:" % enum_name)
		match_lines.append("\t\t\treturn %s.new()" % class_name_str)
	var generated := "\n".join([
		"class_name SceneItemGenerator",
		"extends Object",
		"",
		"enum SCENE_ITEM {",
		"\n".join(enum_lines),
		"}",
		"",
		"static func generate(item : SCENE_ITEM) -> SceneItemBase:",
		"\tmatch item:",
		"\n".join(match_lines),
		"\t",
		"\tprinterr(\"GENERATED UNSOPORTED SCENE ITEM\")",
		"\treturn SceneItemBase.new()",
	]) + "\n"
	_write_generated(GENERATOR_PATH, generated)


func _write_generated(path: String, generated: String) -> void:
	var body := generated.rstrip("\n") + "\n\n" + SKIP_MARKER
	var custom_tail := _read_custom_tail(path)
	var contents := body + custom_tail
	if not contents.ends_with("\n"):
		contents += "\n"
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		printerr("GenerateSceneItems: could not write ", path, " (", FileAccess.get_open_error(), ")")
		return
	file.store_string(contents)


func _read_custom_tail(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	var content := file.get_as_text()
	var idx := content.find(SKIP_MARKER)
	if idx < 0:
		return ""
	return content.substr(idx + SKIP_MARKER.length())


func _to_enum_name(id: String) -> String:
	return id.to_upper()


func _to_pascal_case(id: String) -> String:
	var result := ""
	for part in id.split("_"):
		if part.is_empty():
			continue
		result += part.substr(0, 1).to_upper() + part.substr(1)
	return result


func _gdscript_literal(value: Variant) -> String:
	match typeof(value):
		TYPE_BOOL:
			return "true" if value else "false"
		TYPE_STRING:
			return JSON.stringify(value)
		TYPE_INT, TYPE_FLOAT:
			return str(value)
		_:
			return JSON.stringify(value)
