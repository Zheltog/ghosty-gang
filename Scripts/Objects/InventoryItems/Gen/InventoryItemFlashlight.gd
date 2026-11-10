class_name InventoryItemFlashlight
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT
	equip_time = 1.0
	actions = {"e":{"name":"switch on/off","name_rus":"включить/выключить"}}

# SKIP GENERATION

const SOUND_ON = "res://Assets/Audio/Sounds/flashlight_on.mp3"
const SOUND_OFF = "res://Assets/Audio/Sounds/flashlight_off.mp3"

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	if action == "e":
		light_on = !light_on
		if light_on:
			play_sound(SOUND_ON)
		else:
			play_sound(SOUND_OFF)
		_emit_hover_changed(equipped_item_ui)

func _emit_hover_changed(from : Node) -> void:
	var node := from
	while node:
		if node is Inventory:
			(node as Inventory).hover_changed.emit()
			return
		node = node.get_parent()

static var light_on : bool = false;
