class_name InventoryItemBase
extends Object

var _item_ui : InventoryItemUI
func set_item_ui(ui : InventoryItemUI) -> void:
	_item_ui = ui

var item : InventoryItemGenerator.INVENTORY_ITEM

var equip_time : float = 0.0
var actions : Dictionary = {}

func take_action(action : String) -> void:
	return
