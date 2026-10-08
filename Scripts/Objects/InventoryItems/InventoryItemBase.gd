class_name InventoryItemBase
extends Object

var item : InventoryItemGenerator.INVENTORY_ITEM

var equip_time : float = 0.0
var actions : Dictionary = {}

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	return

func on_equipped(_equipped_item_ui: EquippedItemUI) -> void:
	pass

# Returns true when the click on target is consumed by this equipped item.
func use_on(_target: SceneItemUI) -> bool:
	return false

func inventory_texture_path() -> String:
	return ""

func play_sound(resource_name: String) -> void:
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = resource_name
	CommonAudioProcessor.process_sound(command)

func process_equipped(_delta: float, _equipped_item_ui: EquippedItemUI) -> void:
	pass
