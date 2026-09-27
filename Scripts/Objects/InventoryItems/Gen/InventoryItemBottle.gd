class_name InventoryItemBottle
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.BOTTLE
	equip_time = 1.0
	actions = {"e":{"name":"drink","name_rus":"выпить"}}

# SKIP GENERATION

func take_action(action : String) -> void:
	if action == "e":
		play_ui_animations_once("drink")
