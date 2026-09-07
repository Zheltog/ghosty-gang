class_name InventoryItemsHolder
extends Control

@export var bring_up_y_diff : float = 280.0
@export var inventory : Inventory

@onready var item_placer: InventoryItemPlacer = $InventoryBackground/ItemPlacer
@onready var hide_button: TextureButton = $HideButton
@onready var show_button: TextureButton = $ShowButton

var _highlighted_items : Array[InventoryItemUI]
var processing_item : InventoryItemUI
var selected_item : InventoryItemUI

func _ready() -> void:
	#TODO: remove - for debug console
	add_to_group("inventory_holder")
	bring_down()
	hide_button.button_down.connect(bring_down)
	show_button.button_down.connect(bring_up)
	for child in item_placer.get_children():
		if child is InventoryItemUI:
			item_placer.items.append(child)
			child.set_holder(self)
	item_placer.place_items()

func add_item(item_id : InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	var item_ui = InventoryItemUiGenerator.generate(item_id)
	item_ui.set_holder(self)
	item_placer.add_item(item_ui)
	return item_ui

func add_item_by_name(item_name : String) -> InventoryItemUI:
	var key := item_name.strip_edges().to_upper()
	if not InventoryItemGenerator.INVENTORY_ITEM.keys().has(key):
		printerr("Unknown inventory item: ", item_name)
		return null
	return add_item(InventoryItemGenerator.INVENTORY_ITEM[key])

func _physics_process(_delta : float) -> void:
	_sync_hovered_items()

# [0] — самый верхний спрайт под курсором (z_index, затем порядок в дереве).
func highlighted_item() -> InventoryItemUI:
	if _highlighted_items.size() > 0:
		return _highlighted_items[0]
	return null

func _sync_hovered_items() -> void:
	var hovered : Array[InventoryItemUI] = []
	for area in Area2DUtils.get_at_mouse(self):
		var item := _inventory_item_from_collider(area)
		if item != null and not hovered.has(item):
			hovered.append(item)
	_highlighted_items = hovered

func _inventory_item_from_collider(collider : Object) -> InventoryItemUI:
	var node := collider as Node
	while node:
		if node is InventoryItemUI and item_placer.items.has(node):
			return node
		node = node.get_parent()
	return null

func start_processing_item(item : InventoryItemUI) -> void:
	processing_item = item

func equip_item(item : InventoryItemUI) -> void:
	selected_item = item
	inventory.equip_item(item)
	bring_down()

var _up = true

func bring_up() -> void:
	if _up:
		return
	hide_button.visible = true
	show_button.visible = false
	position.y -= bring_up_y_diff
	_up = true

func bring_down() -> void:
	if !_up:
		return
	hide_button.visible = false
	show_button.visible = true
	position.y += bring_up_y_diff
	_up = false
