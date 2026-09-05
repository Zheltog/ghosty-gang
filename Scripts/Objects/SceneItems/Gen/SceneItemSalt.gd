class_name SceneItemSalt
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.SALT
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.SALT
	ink_story_view = "EMPTY FOR NOW - WILL FILL LATER"

# SKIP GENERATION
