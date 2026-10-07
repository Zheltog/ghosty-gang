class_name InventoryItemGun
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.GUN
	equip_time = 1.0

# SKIP GENERATION



func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	if action != "lmb":
		return
	
