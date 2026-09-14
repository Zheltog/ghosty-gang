class_name Inventory
extends Control

@onready var equipped_item_display: TextureRect = $EquippedItemDisplay
@onready var inventory_holder: InventoryItemsHolder = $InventoryHolder

var equipped_item : InventoryItemUI

func _ready() -> void:
	equipped_item_display.texture = null
	InkFunctions.subscribe(self)

func unequip_item() -> void:
	equipped_item_display.texture = null
	equipped_item = null
	#TODO: call signals

func add_item_str(item_id : String) -> InventoryItemUI:
	var key := item_id.strip_edges().to_upper()
	if not InventoryItemGenerator.INVENTORY_ITEM.keys().has(key):
		printerr("Unknown inventory item: ", item_id)
		return null
	return add_item(InventoryItemGenerator.INVENTORY_ITEM[key])

func add_item(item_id: InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	return inventory_holder.add_item(item_id)

func equip_item(item_ui : InventoryItemUI) -> void:
	equipped_item_display.texture = load(item_ui.generate_equiped_texture_path())
	equipped_item = item_ui
	#TODO: call signals
