class_name SceneItemBase
extends Object

var item : SceneItemGenerator.SCENE_ITEM

var pickable : bool = false
var equiped_immediately : bool = false
var inventory_item : InventoryItemGenerator.INVENTORY_ITEM
# path to json with ink story, which happens if you press look at the object
var ink_story_view : String

func press() -> SceneItemPressResult:
	return SceneItemPressResult.new()
