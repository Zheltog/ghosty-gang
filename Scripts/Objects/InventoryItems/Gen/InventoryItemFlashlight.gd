class_name InventoryItemFlashlight
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT
	equip_time = 1.0
	actions = {"e":{"name":"switch on/off","name_rus":"включить/выключить"}}

# SKIP GENERATION

const SOUND_ON = "res://Assets/Audio/Sounds/flashlight_on.mp3"
const SOUND_OFF = "res://Assets/Audio/Sounds/flashlight_off.mp3"

func take_action(action : String, _equipped_item_ui : EquippedItemUI) -> void:
	if action == "e":
		light_on = !light_on
		if light_on:
			play_sound(SOUND_ON)
		else:
			play_sound(SOUND_OFF)
		
	
static var light_on : bool = false;
