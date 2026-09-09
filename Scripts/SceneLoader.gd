extends Node

enum SCENE {
	NONE,
	STARTING_MENU,
	STARTING_CUTSCENE_1,
	STARTING_CUTSCENE_2,
	MAP,
	NEAR_HOUSE,
	INSIDE_HOUSE,
	CUTSCENE_BOY_DEATH,
}

var _starting_menu: PackedScene = preload("res://Scenes/Preview/StartingMenu.tscn")
var _starting_cutscene_1: PackedScene = preload("res://Scenes/Preview/StartingCutscene1.tscn")
var _starting_cutscene_2: PackedScene = preload("res://Scenes/Preview/StartingCutscene2.tscn")
var _map: PackedScene = preload("res://Scenes/Preview/Map.tscn")
var _near_house: PackedScene = preload("res://Scenes/Preview/NearHouse.tscn")
var _inside_house: PackedScene = preload("res://Scenes/Preview/InsideHouse.tscn")
var _cutscene_boy_death: PackedScene = preload("res://Scenes/Preview/CutsceneBoyDeath.tscn")

func change_scene(scene: SCENE) -> void:
	var packed: PackedScene = null
	match scene:
		SCENE.NONE:
			printerr("SceneLoader: cannot change to SCENE.NONE")
			return
		SCENE.STARTING_MENU:
			packed = _starting_menu
		SCENE.STARTING_CUTSCENE_1:
			packed = _starting_cutscene_1
		SCENE.STARTING_CUTSCENE_2:
			packed = _starting_cutscene_2
		SCENE.MAP:
			packed = _map
		SCENE.NEAR_HOUSE:
			packed = _near_house
		SCENE.INSIDE_HOUSE:
			packed = _inside_house
		SCENE.CUTSCENE_BOY_DEATH:
			packed = _cutscene_boy_death
		_:
			printerr("SceneLoader: unsupported scene ", scene)
			return
	get_tree().change_scene_to_packed(packed)
