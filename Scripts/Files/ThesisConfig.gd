class_name ThesisConfig

var theses: Dictionary

func to_dictionary() -> Dictionary:
	return {
		"theses": theses
	}

func get_by_group(group: String) -> Dictionary:
	return theses.get(group, {})

func get_by_group_known(group: String, known: Array) -> Array:
	var by_group = get_by_group(group)
	var result = []
	for thesis_name in by_group.keys():
		if known.has(thesis_name):
			result.append(by_group[thesis_name])
	return result

func _init(source: Dictionary = {}) -> void:
	if source.is_empty():
		return
	var t = source.get("theses")
	theses = t if t != null else {}

func _to_string() -> String:
	return str(to_dictionary())
