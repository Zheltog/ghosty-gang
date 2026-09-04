extends Node2D

func _ready() -> void:
	var save = SaveManager.load()
	var theses = ThesisConfigManager.load()
	print(theses.get_by_group_known("bob", save.known_theses))
	save.lang = "en"
	save.known_theses.append("bob_smokes")
	SaveManager.save(save)
	theses = ThesisConfigManager.load()
	print(theses.get_by_group_known("bob", save.known_theses))
