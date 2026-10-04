class_name SaveData

var lang: String = "ru"
var known_theses: Array = [ "bob_spiders" ]
var day: int = 0
var scene: String = ""
var items: Array = []
var global_state: Dictionary = {}

func to_dictionary() -> Dictionary:
	return {
		"lang": lang,
		"known_theses": known_theses,
		"day": day,
		"scene": scene,
		"items": items,
		"global_state": global_state,
	}

func _init(source: Dictionary = {}) -> void:
	if source.is_empty():
		return
	var l = source.get("lang")
	lang = l if l != null else lang
	var kt = source.get("known_theses")
	known_theses = kt if kt != null else known_theses
	if source.has("day"):
		day = int(source["day"])
	if source.has("scene"):
		scene = str(source["scene"])
	var stored_items = source.get("items")
	if stored_items is Array:
		items = stored_items.duplicate()
	var stored_state = source.get("global_state")
	if stored_state is Dictionary:
		global_state = _normalize(stored_state)

func _normalize(value: Variant) -> Variant:
	if value is float and is_equal_approx(value, snappedf(value, 1.0)):
		return int(value)
	if value is Dictionary:
		var copy := {}
		for key in value:
			copy[str(key)] = _normalize(value[key])
		return copy
	if value is Array:
		var copy: Array = []
		for entry in value:
			copy.append(_normalize(entry))
		return copy
	return value

func _to_string() -> String:
	return str(to_dictionary())
