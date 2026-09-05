class_name MapPointConfig

var points: Dictionary

func to_dictionary() -> Dictionary:
	return {
		"points": points
	}

func get_name_by_id(id: String) -> String:
	return get_by_id(id).get("name", "")

func get_description_by_id(id: String) -> String:
	return get_by_id(id).get("description", "")

func get_by_id(id: String) -> Dictionary:
	return points.get(id, {})

func _init(source: Dictionary = {}) -> void:
	if source.is_empty():
		return
	var p = source.get("points")
	points = p if p != null else {}

func _to_string() -> String:
	return str(to_dictionary())
