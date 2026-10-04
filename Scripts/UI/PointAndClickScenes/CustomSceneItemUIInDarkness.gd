class_name CustomSceneItemUIInDarkness
extends CustomSceneItemUIBase

func press_item() -> void:
	if _scene_item == null or _scene_object_manager == null:
		printerr("No scene object manager or scene item")
		return
	if _get_equipped_item().inventory_item_id != InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT:
		return
	if !InventoryItemFlashlight.light_on:
		return
	var press_result := _scene_item.press(_get_equipped_item())
	_scene_object_manager.process_press_result(press_result)

func get_effective_interaction_type() -> INTERACTION_TYPE:
	if !_get_equipped_item():
		return INTERACTION_TYPE.NONE
	if _get_equipped_item().inventory_item_id != InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT:
		return INTERACTION_TYPE.NONE
	if !InventoryItemFlashlight.light_on:
		return INTERACTION_TYPE.NONE
	return INTERACTION_TYPE.LOOK
