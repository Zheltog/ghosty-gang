class_name SceneObjectsManager
extends Node

@export var scene_items : Array[SceneItemUI]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in scene_items:
		item.set_scene_object_manager(self)

class ItemWithIntType:
	var item: SceneItemUI
	var interaction_type: SceneItemBase.INTERACTION_TYPE

# используем массив из-за того, что объекты могут соприкасаться или лежать один в другом.
var _highlighted_items : Array[ItemWithIntType]
func highlight_item(item: SceneItemUI, interaction : SceneItemBase.INTERACTION_TYPE) -> void:
	var item_with_int_type = ItemWithIntType.new()
	item_with_int_type.item = item
	item_with_int_type.interaction_type = interaction
	_highlighted_items.insert(0, item_with_int_type)
	update_mouse_cursor()

func unhighlight_item(item: SceneItemUI) -> void:
	for i in range(_highlighted_items.size()):
		if _highlighted_items[i].item == item:
			_highlighted_items.remove_at(i)
			break
	update_mouse_cursor()

func update_mouse_cursor() -> void:
	if _highlighted_items.size() == 0:
		MouseUi.set_mouse_icon(MouseUI.MOUSE_ICON.CURSOR)
	else:
		MouseUi.set_mouse_icon(get_mouse_icon_by_intercation_type(_highlighted_items[0].interaction_type))

func get_mouse_icon_by_intercation_type(intercation : SceneItemBase.INTERACTION_TYPE) -> MouseUI.MOUSE_ICON:
	match intercation:
		SceneItemBase.INTERACTION_TYPE.LOOK:
			return MouseUI.MOUSE_ICON.EYE
		SceneItemBase.INTERACTION_TYPE.TAKE:
			return MouseUI.MOUSE_ICON.HAND
	return MouseUI.MOUSE_ICON.CURSOR
