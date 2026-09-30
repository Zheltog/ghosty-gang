class_name CustomBookSceneItemUI
extends CustomSceneItemUIBase

@export var books_parent: Node2D

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
	var item_id: Variant = _inventory_item_id()
	if inventory == null or item_id == null or inventory.has_item(item_id):
		return
	inventory.add_item(item_id)

func remove_from_inventory() -> void:
	var inventory := _inventory()
	var item_id: Variant = _inventory_item_id()
	if inventory == null or item_id == null:
		return
	inventory.remove_item(item_id)

func _inventory() -> Inventory:
	if _scene_object_manager == null:
		return null
	return _scene_object_manager.inventory

func _inventory_item_id() -> Variant:
	var key := SceneItemGenerator.SCENE_ITEM.find_key(scene_item_id) as String
	if key == null or not InventoryItemGenerator.INVENTORY_ITEM.has(key):
		printerr("CustomBookSceneItemUI: no inventory item for scene item ", scene_item_id)
		return null
	return InventoryItemGenerator.INVENTORY_ITEM[key]
