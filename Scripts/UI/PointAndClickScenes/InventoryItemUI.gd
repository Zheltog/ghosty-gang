class_name InventoryItemUI
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite: TextureRect = $Sprite

@export var inventory_item_id : InventoryItemGenerator.INVENTORY_ITEM
var _inventory_item : InventoryItemBase
var _holder : InventoryItemsHolder
var _equip_process : float = 0.0

func set_holder(holder : InventoryItemsHolder) -> void:
	_holder = holder

func generate_texture_path() -> String:
	var item_name = InventoryItemGenerator.INVENTORY_ITEM.find_key(inventory_item_id)
	if item_name == null:
		printerr("item name not set wjen generating texture path")
		return ""
	return "res://Assets/Sprites/InvenotyItems/%s.png" % str(item_name).to_lower()
	
func _ready() -> void:
	sprite.texture = load(generate_texture_path())
	sprite.mouse_entered.connect(_on_mouse_entered)
	sprite.mouse_exited.connect(_on_mouse_exited)
	_inventory_item = InventoryItemGenerator.generate(inventory_item_id)

func _process(delta: float) -> void:
	if _highlited() and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_equip_process += delta
	else:
		_equip_process = 0.0
	
	if _equip_process >= delta:
		_holder.select_item(self)
		
	_update_progress_bar()

func _update_progress_bar() -> void:
	progress_bar.visible = _highlited()
	progress_bar.value = progress_bar.max_value * _equip_process / _inventory_item.equip_time

func _highlited() -> bool:
	return _holder.highlighted_item() == self

func _selected() -> bool:
	return _holder.selected_item == self


func _on_mouse_entered() -> void:
	print(InventoryItemGenerator.INVENTORY_ITEM.find_key(inventory_item_id))
	_holder.highlight_item(self)

func _on_mouse_exited() -> void:
	_holder.unhighlight_item(self)
