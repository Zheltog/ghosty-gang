class_name SceneItemSalt
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.SALT
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.SALT
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
