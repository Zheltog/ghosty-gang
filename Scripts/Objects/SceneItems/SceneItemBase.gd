class_name SceneItemBase
extends RefCounted

var item : SceneItemGenerator.SCENE_ITEM

var pickable : bool = false
var equiped_immediately : bool = false
var inventory_item : InventoryItemGenerator.INVENTORY_ITEM
# path to json with ink story, which happens if you press look at the object
var ink_story_view : String
var disappear_after_pickup : bool = false
var interaction_type_overload: Dictionary = {}
var _host: Node

@warning_ignore("unused_parameter")
func press(equipped_item: InventoryItemUI = null) -> SceneItemPressResult:
	var result := SceneItemPressResult.new()
	if not ink_story_view.is_empty() and ink_story_view.begins_with("res://"):
		result.type = SceneItemPressResult.TYPE.DIALOG
		result.data = ink_story_view
	elif pickable:
		result.type = SceneItemPressResult.TYPE.ADD_ITEM
		result.data = {
			"item": inventory_item,
			"equiped_immediately": equiped_immediately,
		}
		if disappear_after_pickup:
			disappear()
	return result

func get_interaction_overload(equipped_item: InventoryItemUI) -> Variant:
	if equipped_item == null:
		return null
	if not interaction_type_overload.has(equipped_item.inventory_item_id):
		return null
	return interaction_type_overload[equipped_item.inventory_item_id]

func ready(host: Node = null) -> void:
	_host = host
	InkFunctions.subscribe(self)

func disappear() -> void:
	if _host:
		_host.queue_free()
