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

@onready var equipped_item_anchor: Node2D = $EquippedItemDisplay
@onready var inventory_holder: InventoryItemsHolder = $InventoryHolder

var equipped_item : InventoryItemUI
var _equipped_item_ui: EquippedItemUI

func _ready() -> void:
	InkFunctions.subscribe(self)
	update_hint()

func set_locked(is_locked: bool) -> void:
	if inventory_holder:
		inventory_holder.set_locked(is_locked)

func _unhandled_input(event: InputEvent) -> void:
	if equipped_item == null or not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	var action := OS.get_keycode_string(key_event.keycode).to_lower()
	if not equipped_item.get_actions().has(action):
		return
	var viewport := get_viewport()
	if viewport:
		viewport.set_input_as_handled()
	var action_name := str(equipped_item.get_actions()[action].get("name", ""))
	equipped_item.take_action(action, _equipped_item_ui)
	if dialog_controller:
		dialog_controller.try_action(action_name)
	update_hint()

func unequip_item() -> void:
	if equipped_item == null:
		return
	var item_id := equipped_item.inventory_item_id
	_clear_equipped_item_ui()
	equipped_item = null
	notify_dialog_event(EVENT.UNEQUIP, item_id)
	update_hint()

func close() -> void:
	if inventory_holder:
		inventory_holder.bring_down()

func add_item_str(item_id : String) -> InventoryItemUI:
	var key := item_id.strip_edges().to_upper()
	if not InventoryItemGenerator.INVENTORY_ITEM.keys().has(key):
		printerr("Unknown inventory item: ", item_id)
		return null
	return add_item(InventoryItemGenerator.INVENTORY_ITEM[key])

func add_item(item_id: InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	var existing := inventory_holder.get_item(item_id)
	if existing != null:
		return existing
	var item_ui := inventory_holder.add_item(item_id)
	_play_pickup_sound()
	notify_dialog_event(EVENT.PICKUP, item_id)
	return item_ui

func _play_pickup_sound() -> void:
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = "res://Assets/Audio/Sounds/menu_tick_1.mp3"
	CommonAudioProcessor.process_sound(command)

func has_item(item_id: InventoryItemGenerator.INVENTORY_ITEM) -> bool:
	return inventory_holder.has_item(item_id)

func remove_item_str(item_id: String) -> void:
	var key := item_id.strip_edges().to_upper()
	if not InventoryItemGenerator.INVENTORY_ITEM.keys().has(key):
		printerr("Unknown inventory item: ", item_id)
		return
	remove_item(InventoryItemGenerator.INVENTORY_ITEM[key])

func remove_item(item_id: InventoryItemGenerator.INVENTORY_ITEM) -> void:
	inventory_holder.remove_item(item_id)

func equip_item(item_ui : InventoryItemUI) -> void:
	if equipped_item == item_ui:
		return
	if equipped_item != null:
		unequip_item()
	_equipped_item_ui = EquippedItemUIGenerator.generate(item_ui.inventory_item_id)
	_equipped_item_ui.inventory_item = item_ui.get_inventory_item()
	equipped_item_anchor.add_child(_equipped_item_ui)
	item_ui.get_inventory_item().on_equipped(_equipped_item_ui)
	equipped_item = item_ui
	notify_dialog_event(EVENT.EQUIP, item_ui.inventory_item_id)
	update_hint()

func _clear_equipped_item_ui() -> void:
	if _equipped_item_ui == null:
		return
	_equipped_item_ui.queue_free()
	_equipped_item_ui = null

func notify_dialog_event(event: EVENT, item_id: InventoryItemGenerator.INVENTORY_ITEM) -> void:
	if dialog_controller:
		dialog_controller.try_inventory_choice(event, item_id)
	if item_id != InventoryItemGenerator.INVENTORY_ITEM.GUN:
		return
	if event != EVENT.EQUIP and event != EVENT.UNEQUIP:
		return
	var house := HouseSceneBase.current_house_scene as HouseScenePreview
	if house == null or house.scene_states == null:
		return
	house.scene_states.process_event("gun_drawn" if event == EVENT.EQUIP else "gun_holstered")

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
