class_name InventoryItemFlashlight
extends InventoryItemBase

const SOUND_ON := "res://Assets/Audio/Sounds/flashlight_on.mp3"
const SOUND_OFF := "res://Assets/Audio/Sounds/flashlight_off.mp3"

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
			play_sound(SOUND_ON)
		else:
			_equipped_item_ui.set_ui_animation("default")
			play_sound(SOUND_OFF)
		
	
static var light_on : bool = false;
