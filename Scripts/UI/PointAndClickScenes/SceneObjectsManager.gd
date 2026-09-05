class_name SceneObjectsManager
extends Node

@export var scene_items : Array[SceneItemUI]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in scene_items:
		item.set_scene_object_manager(self)

func item_pressed(item : SceneItemUI) -> void:
	if _highlighted_items.is_empty() or _highlighted_items[0] != item:
		return
	item.press_ui()
		
# используем массив из-за того, что объекты могут соприкасаться или лежать один в другом.
# [0] — самый верхний спрайт под курсором (z_index, затем порядок в дереве).
var _highlighted_items : Array[SceneItemUI]
func highlight_item(item: SceneItemUI) -> void:
	var insert_at := _highlighted_items.size()
	for i in _highlighted_items.size():
		if _is_in_front_of(item, _highlighted_items[i]):
			insert_at = i
			break
	_highlighted_items.insert(insert_at, item)
	update_mouse_cursor()

func _is_in_front_of(a: SceneItemUI, b: SceneItemUI) -> bool:
	if a.z_index != b.z_index:
		return a.z_index > b.z_index
	return a.is_greater_than(b)

func unhighlight_item(item: SceneItemUI) -> void:
	for i in range(_highlighted_items.size()):
		if _highlighted_items[i] == item:
			_highlighted_items.remove_at(i)
			break
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
