class_name InventoryItemPlacer
extends Node2D

@export_category("placement_settings")
@export var num_columns : int = 5
@export var step_x : float = 60
@export var step_y : float = 60

var items : Array[InventoryItemUI]

func place_items() -> void:
	var pos = Vector2(0, 0)
	var cur_column : int = 0
	for item in items:
		item.position = pos
		cur_column += 1
		if cur_column < num_columns:
			pos.x += step_x
		else:
			pos.y += step_y
			pos.x = 0.0
			cur_column = 0

func remove_item(item : InventoryItemUI) -> void:
	remove_child(item)
	items.erase(item)

func add_item(item : InventoryItemUI) -> void:
	add_child(item)
	items.append(item)
	place_items()
