class_name InventoryItemUIGenerator
extends Object

const INVENTORY_ITEM_UI = preload("uid://k5wkjjopjdi")

func generate(item : InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	var item_ui = INVENTORY_ITEM_UI.instantiate() as InventoryItemUI
	item_ui.inventory_item_id = item
	return item_ui

# SKIP GENERATION
