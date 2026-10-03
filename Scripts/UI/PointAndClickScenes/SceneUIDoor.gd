class_name SceneUIDoor
extends SceneItemUI

@export var target_room: String = ""

func _ready() -> void:
	scene_item_id = SceneItemGenerator.SCENE_ITEM.NONE
	intercation_type = INTERACTION_TYPE.MOVE
	super._ready()

func press_item() -> void:
	var house := get_tree().current_scene as HouseSceneBase
	if house == null:
		printerr("SceneUIDoor: current scene is not HouseSceneBase")
		return
	if house.movement_locked:
		return
	if target_room.is_empty():
		printerr("SceneUIDoor: target_room is empty")
		return
	house.load_room(target_room)

func get_effective_interaction_type() -> INTERACTION_TYPE:
	var house := get_tree().current_scene as HouseSceneBase
	if house and house.movement_locked:
		return INTERACTION_TYPE.NONE
	return INTERACTION_TYPE.MOVE
