class_name InkTagParser

extends RefCounted

static func parse(tags: Array[String]) -> Dictionary:
	var parsed_tags := {}

	for tag in tags:
		var normalized_tag := tag.strip_edges()
		if normalized_tag.is_empty():
			continue

		var separator_index := normalized_tag.find(":")
		if separator_index == -1:
			parsed_tags[normalized_tag.to_lower()] = ""
			continue

		var key := normalized_tag.left(separator_index).strip_edges().to_lower()
		var value := normalized_tag.substr(separator_index + 1).strip_edges()
		if key.is_empty():
			continue

		parsed_tags[key] = value

	return parsed_tags

static func values_for_key(tags: Array, key: String) -> Array[String]:
	var normalized_key := key.strip_edges().to_lower()
	var values: Array[String] = []
	if normalized_key.is_empty():
		return values

	for tag in tags:
		var normalized_tag := str(tag).strip_edges()
		var separator_index := normalized_tag.find(":")
		if separator_index == -1:
			continue

		var tag_key := normalized_tag.left(separator_index).strip_edges().to_lower()
		if tag_key != normalized_key:
			continue

		var raw_value := normalized_tag.substr(separator_index + 1).strip_edges()
		for part in raw_value.split(","):
			var value := part.strip_edges()
			if value.is_empty() or values.has(value):
				continue
			values.append(value)

	return values

## Reads `# tag` lines at the top of an ink source (before story content).
static func read_global_tags_from_text(text: String) -> Array[String]:
	var tags: Array[String] = []
	for raw_line in text.split("\n"):
		var line := _strip_comment(str(raw_line).strip_edges())
		if line.is_empty():
			continue

		if line.begins_with("#"):
			var tag := line.substr(1).strip_edges()
			if not tag.is_empty():
				tags.append(tag)
			continue

		var upper := line.to_upper()
		if (
			upper.begins_with("EXTERNAL ")
			or upper.begins_with("VAR ")
			or upper.begins_with("CONST ")
			or upper.begins_with("LIST ")
			or upper.begins_with("INCLUDE ")
		):
			continue

		break

	return tags

static func read_global_tags_from_file(path: String) -> Array[String]:
	return read_global_tags_from_text(read_text_file(path))

## Collects `VAR name` declarations from an ink source.
static func declared_var_names_from_text(text: String) -> Array[String]:
	var names: Array[String] = []
	for raw_line in text.split("\n"):
		var line := _strip_comment(str(raw_line).strip_edges())
		if line.is_empty() or not line.to_upper().begins_with("VAR "):
			continue

		var rest := line.substr(4).strip_edges()
		var equals_index := rest.find("=")
		var variable_name := rest if equals_index == -1 else rest.left(equals_index)
		variable_name = variable_name.strip_edges()
		if variable_name.is_empty() or names.has(variable_name):
			continue
		names.append(variable_name)

	return names

static func declared_var_names_from_file(path: String) -> Array[String]:
	return declared_var_names_from_text(read_text_file(path))

static func read_text_file(path: String) -> String:
	if path.is_empty() or not FileAccess.file_exists(path):
		return ""
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		printerr("InkTagParser: failed to open ", path)
		return ""
	return file.get_as_text()

static func _strip_comment(line: String) -> String:
	var comment_index := line.find("//")
	if comment_index == -1:
		return line
	return line.left(comment_index).strip_edges()
