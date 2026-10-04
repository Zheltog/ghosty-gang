class_name SceneItemBase
extends RefCounted

enum AFTER_PICKUP {
	DISAPPEAR,
	HIDE,
	NOTHING,
}

var item : SceneItemGenerator.SCENE_ITEM

var pickable : bool = false
var pickup_time : float = 0.0
var equiped_immediately : bool = false
var inventory_item : InventoryItemGenerator.INVENTORY_ITEM
# path to an ink story played when this object is used
var ink_story_view : String
var after_pickup: AFTER_PICKUP = AFTER_PICKUP.NOTHING
# null keeps the SceneItemUI export. An equipped-item patch can replace it.
var interaction_type: Variant = null
# equipped inventory item -> property names and the values that replace them
var interaction_overload: Dictionary = {}
var _host: SceneItemUI
var _equipped_base: Dictionary = {}

func press(equipped_item: InventoryItemUI = null) -> SceneItemPressResult:
	apply_equipped(equipped_item)
	# Later rooms can register another instance of the same class. The click
	# that opened this dialog is the object ink should act on.
	InkFunctions.subscribe(self)
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
		match after_pickup:
			AFTER_PICKUP.DISAPPEAR:
				disappear()
			AFTER_PICKUP.HIDE:
				hide_self()
	return result

func apply_equipped(equipped_item: InventoryItemUI) -> void:
	for property in _equipped_base:
		set(property, _equipped_base[property])
	if equipped_item == null:
		return
	var patch: Variant = interaction_overload.get(equipped_item.inventory_item_id)
	if typeof(patch) != TYPE_DICTIONARY:
		return
	for property in patch:
		set(property, patch[property])

func ready(host: SceneItemUI = null) -> void:
	_host = host
	_equipped_base = _snapshot_overload_properties()
	InkFunctions.subscribe(self)

func _snapshot_overload_properties() -> Dictionary:
	var snapshot := {}
	for patch in interaction_overload.values():
		if typeof(patch) != TYPE_DICTIONARY:
			continue
		for property in patch:
			if snapshot.has(property):
				continue
			snapshot[property] = get(property)
	return snapshot

func hide_self() -> void:
	if _host:
		_host.hide_self()

func disappear() -> void:
	if _host == null or not is_instance_valid(_host):
		return
	_host.hide()
	_host.queue_free()
