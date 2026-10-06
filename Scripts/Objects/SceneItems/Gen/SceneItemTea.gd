class_name SceneItemTea
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.TEA
	pickable = true
	equiped_immediately = true
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.TEA
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
