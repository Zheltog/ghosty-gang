class_name SceneItemBottle
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.BOTTLE
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.BOTTLE
	disappear_after_pickup = true

# SKIP GENERATION
