class_name SceneItemCigarettes
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.CIGARETTES
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.CIGARETTES
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
