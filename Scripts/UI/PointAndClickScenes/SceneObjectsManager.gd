class_name SceneObjectsManager
extends Node2D

@export var scene_items : Array[SceneItemUI]
@export var inventory : Inventory

func _ready() -> void:
	InkFunctions.subscribe(self)
	for item in scene_items:
		item.set_scene_object_manager(self)

func _physics_process(_delta : float) -> void:
	_sync_hovered_items()

func item_pressed(item : SceneItemUI) -> void:
	if _highlighted_items.is_empty() or _highlighted_items[0] != item:
		return
	item.press_ui()

# [0] — самый верхний спрайт под курсором (z_index, затем порядок в дереве).
var _highlighted_items : Array[SceneItemUI]

func _sync_hovered_items() -> void:
	var hovered : Array[SceneItemUI] = []
	for area in Area2DUtils.get_at_mouse(self):
		var item := _scene_item_from_collider(area)
		if item != null and not hovered.has(item):
			hovered.append(item)
	_set_hovered_items(hovered)

func _scene_item_from_collider(collider : Object) -> SceneItemUI:
	var node := collider as Node
	while node:
		if node is SceneItemUI and scene_items.has(node) and node.is_visible_in_tree():
			return node
		node = node.get_parent()
	return null

func _set_hovered_items(hovered : Array[SceneItemUI]) -> void:
	var previous_top : SceneItemUI = null
	if not _highlighted_items.is_empty() and is_instance_valid(_highlighted_items[0]):
		previous_top = _highlighted_items[0]
	for item in _highlighted_items:
		if not is_instance_valid(item):
			continue
		if not hovered.has(item):
			item.release()
	var hovered_top : SceneItemUI = null
	if not hovered.is_empty():
		hovered_top = hovered[0]
	_highlighted_items = hovered
	if previous_top != hovered_top:
		update_mouse_cursor()

func process_press_result(result : SceneItemPressResult) -> void:
	match result.type:
		SceneItemPressResult.TYPE.DIALOG:
			var dialog := NodeUtils.get_child_of_type(get_tree().current_scene, DialogController) as DialogController
			if dialog == null:
				printerr("SceneObjectsManager: no DialogController in current scene")
				return
			if dialog.load_story(str(result.data)):
				dialog.start_story()
		SceneItemPressResult.TYPE.CHANGE_ROOM:
			_process_change_room(result.data)
		SceneItemPressResult.TYPE.ADD_ITEM:
			_process_add_item(result.data)
		_:
			pass

func _process_change_room(data: Variant) -> void:
	var house := get_tree().current_scene as HouseScenePreview
	if house == null:
		printerr("SceneObjectsManager: current scene cannot change rooms")
		return
	house.change_room(str(data))

func _process_add_item(data: Variant) -> void:
	if inventory == null:
		printerr("SceneObjectsManager: no Inventory assigned")
		return
	if typeof(data) != TYPE_DICTIONARY:
		printerr("SceneObjectsManager: ADD_ITEM data must be a Dictionary")
		return
	var item_id: InventoryItemGenerator.INVENTORY_ITEM = data["item"]
	var item_ui := inventory.add_item(item_id)
	if data.get("equiped_immediately", false):
		inventory.equip_item(item_ui)

func update_mouse_cursor() -> void:
	if _highlighted_items.size() == 0:
		MouseUi.set_mouse_icon(MouseUI.MOUSE_ICON.CURSOR)
	else:
		MouseUi.set_mouse_icon(get_mouse_icon_by_intercation_type(_highlighted_items[0].intercation_type))

func get_mouse_icon_by_intercation_type(intercation : SceneItemUI.INTERACTION_TYPE) -> MouseUI.MOUSE_ICON:
	match intercation:
		SceneItemUI.INTERACTION_TYPE.LOOK:
			return MouseUI.MOUSE_ICON.EYE
		SceneItemUI.INTERACTION_TYPE.TAKE:
			return MouseUI.MOUSE_ICON.HAND
	return MouseUI.MOUSE_ICON.CURSOR
