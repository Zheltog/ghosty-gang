class_name InventoryItemBase
extends Object

var item : InventoryItemGenerator.INVENTORY_ITEM

var equip_time : float = 0.0
var actions : Dictionary = {}

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	return

func play_sound(resource_name: String) -> void:
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = resource_name
	CommonAudioProcessor.process_sound(command)

func process_equipped(_delta: float, _equipped_item_ui: EquippedItemUI) -> void:
	pass
