class_name Inventory
extends Control

enum EVENT {
	PICKUP,
	EQUIP,
	EQUIP_START,
	UNEQUIP,
	UNEQUIP_START,
}

@export var dialog_controller: DialogController

@onready var hint_rect: TextureRect = $HintRect
@onready var hint_label: Label = $HintRect/HintLabel

@onready var equipped_item_display: TextureRect = $EquippedItemDisplay
@onready var inventory_holder: InventoryItemsHolder = $InventoryHolder

var equipped_item : InventoryItemUI

func _ready() -> void:
	equipped_item_display.texture = null
	InkFunctions.subscribe(self)
	update_hint()

func unequip_item() -> void:
	if equipped_item == null:
		return
	var item_id := equipped_item.inventory_item_id
	equipped_item_display.texture = null
	equipped_item = null
	notify_dialog_event(EVENT.UNEQUIP, item_id)
	update_hint()

func add_item_str(item_id : String) -> InventoryItemUI:
	var key := item_id.strip_edges().to_upper()
	if not InventoryItemGenerator.INVENTORY_ITEM.keys().has(key):
		printerr("Unknown inventory item: ", item_id)
		return null
	return add_item(InventoryItemGenerator.INVENTORY_ITEM[key])

func add_item(item_id: InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	var item_ui := inventory_holder.add_item(item_id)
	notify_dialog_event(EVENT.PICKUP, item_id)
	return item_ui

func equip_item(item_ui : InventoryItemUI) -> void:
	if equipped_item == item_ui:
		return
	if equipped_item != null:
		unequip_item()
	equipped_item_display.texture = load(item_ui.generate_equiped_texture_path())
	equipped_item = item_ui
	notify_dialog_event(EVENT.EQUIP, item_ui.inventory_item_id)
	update_hint()

func notify_dialog_event(event: EVENT, item_id: InventoryItemGenerator.INVENTORY_ITEM) -> void:
	if dialog_controller:
		dialog_controller.try_inventory_choice(event, item_id)

func update_hint() -> void:
	if !equipped_item:
		hint_rect.hide()
		return
	var hint : Dictionary = equipped_item.get_actions()
	if hint.size() == 0:
		hint_rect.hide()
		return
	var lines: PackedStringArray = []
	for action in hint:
		lines.append(ActionNames.get_action_name(action) + ": " + hint[action]["name_rus"])
	hint_label.text = "\n".join(lines)
	
	hint_rect.show()
