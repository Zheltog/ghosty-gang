class_name InventoryItemsHolder
extends Control

@export var bring_up_diff : float = 280.0

@onready var grid_container: GridContainer = $GridContainer
@onready var hide_button: TextureButton = $HideButton
@onready var show_button: TextureButton = $ShowButton

var _highlighted_items : Array[InventoryItemUI]
var processing_item : InventoryItemUI
var selected_item : InventoryItemUI

func _ready() -> void:
	bring_down()
	hide_button.button_down.connect(bring_down)
	show_button.button_down.connect(bring_up)
	for child in grid_container.get_children():
		if child is InventoryItemUI:
			child.set_holder(self)

func highlight_item(item : InventoryItemUI) -> void:
	_highlighted_items.append(item)

func unhighlight_item(item : InventoryItemUI) -> void:
	_highlighted_items.erase(item)

func highlighted_item() -> InventoryItemUI:
	if _highlighted_items.size() > 0:
		return _highlighted_items[0]
	return null

func start_processing_item(item : InventoryItemUI) -> void:
	processing_item = item

func select_item(item : InventoryItemUI) -> void:
	selected_item = item
	#TODO: display the item somehow, affect the dialog

func check_highligh() -> void:
	pass

func bring_up() -> void:
	hide_button.visible = true
	show_button.visible = false
	position.y -= bring_up_diff

func bring_down() -> void:
	hide_button.visible = false
	show_button.visible = true
	position.y += bring_up_diff
