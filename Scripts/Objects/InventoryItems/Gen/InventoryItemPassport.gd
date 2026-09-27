class_name InventoryItemPassport
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.PASSPORT
	equip_time = 1.0
	actions = {"a":{"name":"previous page","name_rus":"перелистнуть назад"},"d":{"name":"next page","name_rus":"перелистнуть вперед"}}

# SKIP GENERATION

var page : int = 0

func take_action(action : String, equipped_item_ui : EquippedItemUI) -> void:
	if action == "a":
		if page == 0:
			return
		page -= 1
		if page == 0:
			equipped_item_ui.set_ui_animation("default")
		else:
			equipped_item_ui.set_ui_animation("page" + str(page))
	if action == "d":
		if page == 3:
			return
		page += 1
		equipped_item_ui.set_ui_animation("page" + str(page))
