class_name InventoryItemTea
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.TEA
	equip_time = 1.0
	actions = {"e":{"name":"drink","name_rus":"выпить"}}

# SKIP GENERATION

const _EMPTY_INVENTORY := "res://Assets/Sprites/InventoryItems/tea_empty.png"
var _empty := false

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	if action != "e" or _empty:
		return
	_empty = true
	actions = {}
	if equipped_item_ui:
		equipped_item_ui.set_ui_animation("empty")

func on_equipped(equipped_item_ui: EquippedItemUI) -> void:
	if _empty and equipped_item_ui:
		equipped_item_ui.set_ui_animation("empty")

func inventory_texture_path() -> String:
	if _empty:
		return _EMPTY_INVENTORY
	return ""
