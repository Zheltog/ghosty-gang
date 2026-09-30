class_name InventoryItemUI
extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite: Sprite2D = $Sprite2D

@export var inventory_item_id : InventoryItemGenerator.INVENTORY_ITEM
var _inventory_item : InventoryItemBase
var _holder : InventoryItemsHolder
var _equip_process : float = 0.0
var _notified_equip_start : bool = false
var _hold_released : bool = true

func set_holder(holder : InventoryItemsHolder) -> void:
	_holder = holder

func generate_texture_path() -> String:
	var item_name = InventoryItemGenerator.INVENTORY_ITEM.find_key(inventory_item_id)
	if item_name == null:
		printerr("item name not set when generating texture path")
		return ""
	return "res://Assets/Sprites/InventoryItems/%s.png" % str(item_name).to_lower()

func generate_equiped_texture_path() -> String:
	var item_name = InventoryItemGenerator.INVENTORY_ITEM.find_key(inventory_item_id)
	if item_name == null:
		printerr("item name not set when generating euiped texture path")
		return ""
	return "res://Assets/Sprites/EquipedInventoryItems/%s.png" % str(item_name).to_lower()

func get_actions() -> Dictionary:
	return _inventory_item.actions

func get_inventory_item() -> InventoryItemBase:
	return _inventory_item

func take_action(action: String, equipped_item_ui : EquippedItemUI) -> void:
	_inventory_item.take_action(action, equipped_item_ui)

func _ready() -> void:
	sprite.texture = load(generate_texture_path())
	_inventory_item = InventoryItemGenerator.generate(inventory_item_id)

func _process(delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_hold_released = true
		_reset_hold()
		_update_progress_bar()
		return
	if not _highlighted() or not _hold_released:
		_reset_hold()
		_update_progress_bar()
		return
	if _equiped():
		_process_unequip_hold(delta)
	else:
		_process_equip_hold(delta)
	_update_progress_bar()

func _process_equip_hold(delta: float) -> void:
	if not _notified_equip_start:
		_notified_equip_start = true
		_holder.inventory.notify_dialog_event(Inventory.EVENT.EQUIP_START, inventory_item_id)
	_equip_process += delta
	if _equip_process >= _inventory_item.equip_time:
		_hold_released = false
		_holder.equip_item(self)
		_reset_hold()

func _process_unequip_hold(delta: float) -> void:
	if not _notified_equip_start:
		_notified_equip_start = true
		_holder.inventory.notify_dialog_event(Inventory.EVENT.UNEQUIP_START, inventory_item_id)
	_equip_process += delta
	if _equip_process >= _inventory_item.equip_time:
		_hold_released = false
		_holder.unequip_item()
		_reset_hold()

func _reset_hold() -> void:
	_equip_process = 0.0
	_notified_equip_start = false

func _update_progress_bar() -> void:
	progress_bar.visible = _highlighted() and _equip_process > 0.0
	if _inventory_item.equip_time <= 0.0:
		progress_bar.value = progress_bar.max_value
		return
	progress_bar.value = progress_bar.max_value * _equip_process / _inventory_item.equip_time

func _highlighted() -> bool:
	return _holder.highlighted_item() == self

func _equiped() -> bool:
	return _holder.inventory.equipped_item == self
