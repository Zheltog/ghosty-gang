class_name CharacterNames

static func display_name(character_tag: String) -> String:
	var tag := character_tag.strip_edges().to_lower()
	match tag:
		"dossier":
			return "Досье"
		"detective":
			return ""
		"driver":
			return "Водитель"
		"scout":
			if bool(StateManager.get_state("scout_introduced", false)):
				return "Разведчик"
			return "Мальчик"
		"landlady":
			return "Хозяйка"
		"cashier":
			return "Продавщица"
		"engineer":
			return "Инженер"
		"none", "":
			return ""
		_:
			printerr("CharacterNames: no name for '%s'" % character_tag)
			return ""
