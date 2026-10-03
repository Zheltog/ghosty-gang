class_name InventoryItemGenerator
extends Object

enum INVENTORY_ITEM {
	CIGARETTES,
	FLASHLIGHT,
	GUN,
	KEY_BOOKSHELF,
	PASSPORT,
	PHOTO,
	TEA
}

static func generate(item : INVENTORY_ITEM) -> InventoryItemBase:
	match item:
		INVENTORY_ITEM.CIGARETTES:
			return InventoryItemCigarettes.new()
		INVENTORY_ITEM.FLASHLIGHT:
			return InventoryItemFlashlight.new()
		INVENTORY_ITEM.GUN:
			return InventoryItemGun.new()
		INVENTORY_ITEM.KEY_BOOKSHELF:
			return InventoryItemKeyBookshelf.new()
		INVENTORY_ITEM.PASSPORT:
			return InventoryItemPassport.new()
		INVENTORY_ITEM.PHOTO:
			return InventoryItemPhoto.new()
		INVENTORY_ITEM.TEA:
			return InventoryItemTea.new()
	
	printerr("GENERATED UNSOPORTED INVENTORY ITEM")
	return InventoryItemBase.new()

# SKIP GENERATION
