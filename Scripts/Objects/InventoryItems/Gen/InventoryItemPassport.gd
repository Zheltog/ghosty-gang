class_name InventoryItemPassport
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.PASSPORT
	equip_time = 1.0

# SKIP GENERATION

var page : int = 0

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	pass
