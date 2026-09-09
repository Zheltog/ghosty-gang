class_name Inventory
extends Control

@onready var equipped_item_display: TextureRect = $EquippedItemDisplay
@onready var inventory_holder: InventoryItemsHolder = $InventoryHolder

var equipped_item : InventoryItemUI

func _ready() -> void:
	equipped_item_display.texture = null

func unequip_item() -> void:
	equipped_item_display.texture = null
	equipped_item = null
	#TODO: call signals

func equip_item(item_ui : InventoryItemUI) -> void:
	equipped_item_display.texture = load(item_ui.generate_equiped_texture_path())
	equipped_item = item_ui
	#TODO: call signals
