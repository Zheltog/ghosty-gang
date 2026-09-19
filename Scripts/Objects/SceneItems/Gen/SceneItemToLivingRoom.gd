class_name SceneItemToLivingRoom
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.TO_LIVING_ROOM
	pickable = false
	room_exit = "living_room"

# SKIP GENERATION
