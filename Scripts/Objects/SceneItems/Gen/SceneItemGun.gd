class_name SceneItemGun
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.GUN
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.GUN
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
