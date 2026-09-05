class_name SaveData

var lang: String = "ru"
var known_theses: Array = [ "bob_spiders" ]

func to_dictionary() -> Dictionary:
	return {
		"lang": lang,
		"known_theses": known_theses
	}

func _init(source: Dictionary = {}) -> void:
	if source.is_empty():
		return
	var l = source.get("lang")
	lang = l if l != null else lang
	var kt = source.get("known_theses")
	known_theses = kt if kt != null else known_theses

func _to_string() -> String:
	return str(to_dictionary())
