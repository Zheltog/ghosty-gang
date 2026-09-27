class_name InventoryItemGenerator
extends Object

enum INVENTORY_ITEM {
	SALT,
	PEPPER,
	BOTTLE,
	PASSPORT,
	FLASHLIGHT,
	PHOTO
}

static func generate(item : INVENTORY_ITEM) -> InventoryItemBase:
	match item:
		INVENTORY_ITEM.SALT:
			return InventoryItemSalt.new()
		INVENTORY_ITEM.PEPPER:
			return InventoryItemPepper.new()
		INVENTORY_ITEM.BOTTLE:
			return InventoryItemBottle.new()
		INVENTORY_ITEM.PASSPORT:
			return InventoryItemPassport.new()
		INVENTORY_ITEM.FLASHLIGHT:
			return InventoryItemFlashlight.new()
		INVENTORY_ITEM.PHOTO:
			return InventoryItemPhoto.new()
	
	printerr("GENERATED UNSOPORTED INVENTORY ITEM")
	return InventoryItemBase.new()

# SKIP GENERATION
