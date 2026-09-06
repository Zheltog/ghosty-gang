class_name InventoryItemUI
extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite: Sprite2D = $Sprite2D


@export var inventory_item_id : InventoryItemGenerator.INVENTORY_ITEM
var _inventory_item : InventoryItemBase
var _holder : InventoryItemsHolder
var _equip_process : float = 0.0

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

func _ready() -> void:
	sprite.texture = load(generate_texture_path())
	_inventory_item = InventoryItemGenerator.generate(inventory_item_id)

func _process(delta: float) -> void:
	if _equiped():
		return
	if _highlited() and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_equip_process += delta
	else:
		_equip_process = 0.0
	
	if _equip_process >= _inventory_item.equip_time:
		_holder.equip_item(self)
		_equip_process = 0.0
		
	_update_progress_bar()

func _update_progress_bar() -> void:
	progress_bar.visible = _highlited() && !_equiped()
	progress_bar.value = progress_bar.max_value * _equip_process / _inventory_item.equip_time

func _highlited() -> bool:
	return _holder.highlighted_item() == self

func _equiped() -> bool:
	return _holder.inventory.equipped_item == self
