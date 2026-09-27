class_name InventoryItemBottle
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.BOTTLE
	equip_time = 1.0
	actions = {"e":{"name":"drink","name_rus":"выпить"}}

# SKIP GENERATION

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	if action == "e":
		equipped_item_ui.play_ui_animations_once("drink")
