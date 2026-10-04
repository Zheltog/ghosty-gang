class_name InventoryItemsHolder
extends Control

@export var bring_up_y_diff : float = 280.0
@export var inventory : Inventory

@onready var item_placer: InventoryItemPlacer = $InventoryBackground/ItemPlacer
@onready var hide_button: TextureButton = $HideButton
@onready var show_button: TextureButton = $ShowButton

var _highlighted_items : Array[InventoryItemUI]
var _cursor_item : InventoryItemUI
var _cursor_equipped : InventoryItemUI
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
	for item_id in SaveManager.item_ids():
		_create_item(item_id)

func add_item(item_id : InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	SaveManager.remember_item(item_id)
	return _create_item(item_id)

func _create_item(item_id : InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	var item_ui = InventoryItemUiGenerator.generate(item_id)
	item_ui.set_holder(self)
	item_placer.add_item(item_ui)
	return item_ui

func has_item(item_id : InventoryItemGenerator.INVENTORY_ITEM) -> bool:
	return get_item(item_id) != null

func get_item(item_id : InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	for item in item_placer.items:
		if item.inventory_item_id == item_id:
			return item
	return null

func remove_item(item_id : InventoryItemGenerator.INVENTORY_ITEM) -> void:
	var found : InventoryItemUI = null
	for item in item_placer.items:
		if item.inventory_item_id == item_id:
			found = item
			break
	if found == null:
		return
	if inventory.equipped_item == found:
		inventory.unequip_item()
	SaveManager.forget_item(item_id)
	item_placer.remove_item(found)
	item_placer.place_items()
	found.queue_free()

func add_item_by_name(item_name : String) -> InventoryItemUI:
	var key := item_name.strip_edges().to_upper()
	if not InventoryItemGenerator.INVENTORY_ITEM.keys().has(key):
		printerr("Unknown inventory item: ", item_name)
		return null
	return add_item(InventoryItemGenerator.INVENTORY_ITEM[key])

func _physics_process(_delta : float) -> void:
	_sync_hovered_items()

# [0] — самый верхний спрайт под курсором (видимость, z_index, затем порядок в дереве).
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
	_update_mouse_cursor()

func _update_mouse_cursor() -> void:
	var item := highlighted_item()
	var equipped : InventoryItemUI = null
	if inventory != null:
		equipped = inventory.equipped_item
	if item == _cursor_item and equipped == _cursor_equipped:
		return
	_cursor_item = item
	_cursor_equipped = equipped
	if item == null:
		_restore_scene_cursor()
		return
	if equipped == item:
		MouseUi.set_mouse_icon(MouseUI.MOUSE_ICON.IN)
	else:
		MouseUi.set_mouse_icon(MouseUI.MOUSE_ICON.OUT)

func _restore_scene_cursor() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var manager := NodeUtils.get_child_of_type(scene, SceneObjectsManager) as SceneObjectsManager
	if manager:
		manager.update_mouse_cursor()

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

func unequip_item() -> void:
	selected_item = null
	inventory.unequip_item()

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
