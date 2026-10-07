extends Node

const LOAD_TAG := "load"
const SAVE_TAG := "save"

var _values: Dictionary = {}

func has_value(variable_name: String) -> bool:
	return _values.has(variable_name)

func get_value(variable_name: String, default_value: Variant = null) -> Variant:
	return _values.get(variable_name, default_value)

func set_value(variable_name: String, value: Variant) -> void:
	_values[variable_name] = value

func clear() -> void:
	_values.clear()

func apply(story: InkStory, story_path: String = "") -> void:
	if story == null:
		return
	var source := _source_text(story, story_path)
	var declared := InkTagParser.declared_var_names_from_text(source)
	for variable_name in InkTagParser.values_for_key(
		InkTagParser.read_global_tags_from_text(source), LOAD_TAG
	):
		if not declared.has(variable_name):
			printerr("InkVariableStore: skip load, no VAR '%s' in %s" % [variable_name, _resolve_story_path(story, story_path)])
			continue
		if _values.has(variable_name):
			story.StoreVariable(variable_name, _values[variable_name])

func capture(story: InkStory, story_path: String = "") -> void:
	if story == null:
		return
	var source := _source_text(story, story_path)
	var declared := InkTagParser.declared_var_names_from_text(source)
	for variable_name in InkTagParser.values_for_key(
		InkTagParser.read_global_tags_from_text(source), SAVE_TAG
	):
		if not declared.has(variable_name):
			printerr("InkVariableStore: skip save, no VAR '%s' in %s" % [variable_name, _resolve_story_path(story, story_path)])
			continue
		_values[variable_name] = story.FetchVariable(variable_name)

func _source_text(story: InkStory, story_path: String) -> String:
	if story != null and story.has_method("GetSourceText"):
		var stored := str(story.GetSourceText())
		if not stored.is_empty():
			return stored
	return InkTagParser.read_text_file(_resolve_story_path(story, story_path))

func _resolve_story_path(story: InkStory, story_path: String) -> String:
	if not story_path.is_empty():
		return story_path
	if story.resource_path.ends_with(".ink"):
		return story.resource_path
	return ""
