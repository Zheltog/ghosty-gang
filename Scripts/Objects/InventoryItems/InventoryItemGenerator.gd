class_name InventoryItemGenerator
extends Object

enum INVENTORY_ITEM {
	SALT,
	PEPPER,
	BOTTLE,
	PASSPORT,
	FLASHLIGHT,
	PHOTO,
	BOOK_1,
	BOOK_2,
	BOOK_KEY,
	KEY_BOOKSHELF
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
		INVENTORY_ITEM.BOOK_1:
			return InventoryItemBook1.new()
		INVENTORY_ITEM.BOOK_2:
			return InventoryItemBook2.new()
		INVENTORY_ITEM.BOOK_KEY:
			return InventoryItemBookKey.new()
		INVENTORY_ITEM.KEY_BOOKSHELF:
			return InventoryItemKeyBookshelf.new()
	
	printerr("GENERATED UNSOPORTED INVENTORY ITEM")
	return InventoryItemBase.new()

# SKIP GENERATION
