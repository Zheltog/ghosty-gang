class_name InventoryItemGenerator
extends Object

enum INVENTORY_ITEM {
	SALT,
	PEPPER
}

static func generate(item : INVENTORY_ITEM) -> InventoryItemBase:
	match item:
		INVENTORY_ITEM.SALT:
			return InventoryItemSalt.new()
		INVENTORY_ITEM.PEPPER:
			return InventoryItemPepper.new()
	
	printerr("GENERATED UNSOPORTED INVENTORY ITEM")
	return InventoryItemBase.new()

# SKIP GENERATION
