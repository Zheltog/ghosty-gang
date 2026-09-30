class_name SceneItemPassport
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.PASSPORT
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.PASSPORT
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
