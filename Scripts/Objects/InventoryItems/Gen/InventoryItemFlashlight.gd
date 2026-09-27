class_name InventoryItemFlashlight
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT
	equip_time = 1.0
	actions = {"e":{"name":"switch on/off","name_rus":"включить/выключить"}}

# SKIP GENERATION

func take_action(action : String, _equipped_item_ui : EquippedItemUI) -> void:
	if action == "e":
		light_on = !light_on
		if light_on:
			_equipped_item_ui.set_ui_animation("on")
		else:
			_equipped_item_ui.set_ui_animation("default")
		
	
static var light_on : bool = false;
