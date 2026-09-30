class_name InventoryItemBase
extends Object

var item : InventoryItemGenerator.INVENTORY_ITEM

var equip_time : float = 0.0
var actions : Dictionary = {}

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	return

func process_equipped(_delta: float, _equipped_item_ui: EquippedItemUI) -> void:
	pass
