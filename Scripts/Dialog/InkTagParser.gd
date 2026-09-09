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
