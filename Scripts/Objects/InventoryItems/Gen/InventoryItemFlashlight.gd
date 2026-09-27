class_name InventoryItemFlashlight
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT
	equip_time = 2.0
	actions = {"e":{"name":"switch on/off","name_rus":"включить/выключить"}}

# SKIP GENERATION
