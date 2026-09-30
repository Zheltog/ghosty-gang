class_name CustomBookSceneItemUI
extends CustomSceneItemUIBase

@export var books_parent: Node2D
@export var inventory_item: InventoryItemGenerator.INVENTORY_ITEM

func _ready() -> void:
	super._ready()
	if books_parent == null:
		books_parent = get_parent() as Node2D

func press_item() -> void:
	if _scene_item == null or _scene_object_manager == null:
		return
	var press_result := _scene_item.press(_get_equipped_item())
	_scene_object_manager.process_press_result(press_result)

func hide_self() -> void:
	if visible:
		_restore_other_books()
		_add_to_inventory()
	super.hide_self()

func _restore_other_books() -> void:
	if books_parent == null:
		return
	for child in books_parent.get_children():
		if child == self or not child is CustomBookSceneItemUI:
			continue
		var book := child as CustomBookSceneItemUI
		book.remove_from_inventory()
		book.show()

func _add_to_inventory() -> void:
	var inventory := _inventory()
	if inventory == null or inventory.has_item(inventory_item):
		return
	inventory.add_item(inventory_item)

func remove_from_inventory() -> void:
	var inventory := _inventory()
	if inventory == null:
		return
	inventory.remove_item(inventory_item)

func _inventory() -> Inventory:
	if _scene_object_manager == null:
		return null
	return _scene_object_manager.inventory
