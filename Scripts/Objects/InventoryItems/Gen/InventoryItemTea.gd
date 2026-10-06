class_name InventoryItemTea
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.TEA
	equip_time = 1.0
	actions = {"e":{"name":"drink","name_rus":"выпить"}}

# SKIP GENERATION

const _EMPTY_INVENTORY := "res://Assets/Sprites/InventoryItems/tea_empty.png"
const _REMOVE_DELAY := 0.75
var _empty := false
var _removed := false

func take_action(action: String, equipped_item_ui: EquippedItemUI) -> void:
	if action != "e" or _empty:
		return
	_empty = true
	actions = {}
	if equipped_item_ui:
		equipped_item_ui.set_ui_animation("empty")
	var scene := _scene()
	if scene == null:
		_remove_from_inventory()
		return
	scene.get_tree().create_timer(_REMOVE_DELAY).timeout.connect(_remove_from_inventory)

func on_equipped(equipped_item_ui: EquippedItemUI) -> void:
	if _empty and equipped_item_ui:
		equipped_item_ui.set_ui_animation("empty")

func inventory_texture_path() -> String:
	if _empty:
		return _EMPTY_INVENTORY
	return ""

func _remove_from_inventory() -> void:
	if _removed:
		return
	_removed = true
	var scene := _scene()
	if scene == null or scene.scene_object_manager == null or scene.scene_object_manager.inventory == null:
		return
	scene.scene_object_manager.inventory.remove_item(item)
	if scene.scene_states:
		scene.scene_states.process_event("reveal_empty_tea")

func _scene() -> HouseScenePreview:
	return HouseSceneBase.current_house_scene as HouseScenePreview
