class_name SceneItemRag
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.RAG
	pickable = true
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.RAG
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR

# SKIP GENERATION
