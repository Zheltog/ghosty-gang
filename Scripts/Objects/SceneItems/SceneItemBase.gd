class_name SceneItemBase
extends Object

var item : SceneItemGenerator.SCENE_ITEM

var pickable : bool = false
var equiped_immediately : bool = false
var inventory_item : InventoryItemGenerator.INVENTORY_ITEM
# path to json with ink story, which happens if you press look at the object
var ink_story_view : String

enum INTERACTION_TYPE {
	LOOK,
	TAKE,
	NONE
}

# TODO: will probably update this logic. It can also be overriden for specific objects
func get_interaction_type() -> INTERACTION_TYPE:
	if ink_story_view:
		return INTERACTION_TYPE.LOOK
	elif pickable:
		return INTERACTION_TYPE.TAKE
	return INTERACTION_TYPE.NONE
