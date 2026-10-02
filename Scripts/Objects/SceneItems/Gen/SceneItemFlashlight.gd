class_name SceneItemFlashlight
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.FLASHLIGHT
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
