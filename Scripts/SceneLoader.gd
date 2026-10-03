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
	PROLOGUE_BUS,
	PROLOGUE_STOP,
	HOTEL_LOBBY,
	HOTEL_FLOOR,
	HOTEL_ROOM,
	HOTEL_DRIVER,
	HOTEL_FOYER,
	HOTEL_INTERVIEW,
	DAY1_SHOP,
}

var _starting_menu: PackedScene = preload("res://Scenes/Preview/StartingMenu.tscn")
var _starting_cutscene_1: PackedScene = preload("res://Scenes/Preview/StartingCutscene1.tscn")
var _starting_cutscene_2: PackedScene = preload("res://Scenes/Preview/StartingCutscene2.tscn")
var _map: PackedScene = preload("res://Scenes/Preview/Map.tscn")
var _near_house: PackedScene = preload("res://Scenes/Preview/NearHouse.tscn")
var _inside_house: PackedScene = preload("res://Scenes/Preview/InsideHouse.tscn")
var _cutscene_boy_death: PackedScene = preload("res://Scenes/Preview/CutsceneBoyDeath.tscn")
var _prologue_bus: PackedScene = preload("res://Scenes/Preview/PrologueBus.tscn")
var _prologue_stop: PackedScene = preload("res://Scenes/Preview/PrologueStop.tscn")
var _hotel_lobby: PackedScene = preload("res://Scenes/Preview/HotelLobby.tscn")
var _hotel_floor: PackedScene = preload("res://Scenes/Preview/HotelFloor.tscn")
var _hotel_room: PackedScene = preload("res://Scenes/Preview/HotelRoom.tscn")
var _hotel_driver: PackedScene = preload("res://Scenes/Preview/HotelDriver.tscn")
var _hotel_foyer: PackedScene = preload("res://Scenes/Preview/HotelFoyer.tscn")
var _hotel_interview: PackedScene = preload("res://Scenes/Preview/HotelInterview.tscn")
var _day1_shop: PackedScene = preload("res://Scenes/Preview/Day1Shop.tscn")

func start_day(day_number: int, scene: SCENE) -> void:
	SaveManager.begin_day(day_number)
	change_scene(scene)

func continue_saved_game() -> bool:
	if not SaveManager.load_checkpoint():
		printerr("SceneLoader: no day checkpoint")
		return false
	var scene := _scene_for_day(SaveManager.day)
	if scene == SCENE.NONE:
		printerr("SceneLoader: no entry scene for day ", SaveManager.day)
		return false
	change_scene(scene)
	return true

func _scene_for_day(day_number: int) -> SCENE:
	match day_number:
		1:
			return SCENE.PROLOGUE_BUS
		_:
			return SCENE.NONE

func scene_from_exit(exit_name: String) -> SCENE:
	match exit_name:
		"hotel_lobby":
			return SCENE.HOTEL_LOBBY
		"hotel_floor":
			return SCENE.HOTEL_FLOOR
		"hotel_room":
			return SCENE.HOTEL_ROOM
		"hotel_driver":
			return SCENE.HOTEL_DRIVER
		"hotel_foyer":
			return SCENE.HOTEL_FOYER
		"hotel_interview":
			return SCENE.HOTEL_INTERVIEW
		"shop":
			return SCENE.DAY1_SHOP
		"map":
			return SCENE.MAP
		_:
			return SCENE.NONE

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
		SCENE.PROLOGUE_BUS:
			packed = _prologue_bus
		SCENE.PROLOGUE_STOP:
			packed = _prologue_stop
		SCENE.HOTEL_LOBBY:
			packed = _hotel_lobby
		SCENE.HOTEL_FLOOR:
			packed = _hotel_floor
		SCENE.HOTEL_ROOM:
			packed = _hotel_room
		SCENE.HOTEL_DRIVER:
			packed = _hotel_driver
		SCENE.HOTEL_FOYER:
			packed = _hotel_foyer
		SCENE.HOTEL_INTERVIEW:
			packed = _hotel_interview
		SCENE.DAY1_SHOP:
			packed = _day1_shop
		_:
			printerr("SceneLoader: unsupported scene ", scene)
			return
	get_tree().change_scene_to_packed(packed)
