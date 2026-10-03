class_name SceneItemKeyBookshelf
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.KEY_BOOKSHELF
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.KEY_BOOKSHELF
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
