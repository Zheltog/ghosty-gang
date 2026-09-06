class_name SceneObjectsManager
extends Node2D

@export var scene_items : Array[SceneItemUI]

func _ready() -> void:
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
		if node is SceneItemUI and scene_items.has(node):
			return node
		node = node.get_parent()
	return null

func _set_hovered_items(hovered : Array[SceneItemUI]) -> void:
	var previous_top : SceneItemUI = null
	if not _highlighted_items.is_empty():
		previous_top = _highlighted_items[0]
	for item in _highlighted_items:
		if not hovered.has(item):
			item.release()
	var hovered_top : SceneItemUI = null
	if not hovered.is_empty():
		hovered_top = hovered[0]
	_highlighted_items = hovered
	if previous_top != hovered_top:
		update_mouse_cursor()

func process_press_result(result : SceneItemPressResult) -> void:
	#TODO:
	print('pressed')
	pass

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
