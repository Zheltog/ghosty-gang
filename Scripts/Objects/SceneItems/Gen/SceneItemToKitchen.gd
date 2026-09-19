class_name SceneItemToKitchen
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.TO_KITCHEN
	pickable = false
	room_exit = "kitchen"

# SKIP GENERATION
