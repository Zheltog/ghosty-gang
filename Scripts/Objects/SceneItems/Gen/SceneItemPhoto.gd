class_name SceneItemPhoto
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.PHOTO
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.PHOTO
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
