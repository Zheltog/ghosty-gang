class_name InventoryItemGun
extends InventoryItemBase

func _init() -> void:
	item = InventoryItemGenerator.INVENTORY_ITEM.GUN
	equip_time = 1.0

# SKIP GENERATION

const SHOOT_ACTION := "shoot"
const SHOOT_SOUND := "res://Assets/Audio/Sounds/gun.mp3"

func use_on(target: SceneItemUI) -> bool:
	if target.get_effective_interaction_type() != SceneItemUI.INTERACTION_TYPE.SHOOT:
		return false
	play_sound(SHOOT_SOUND)
	var scene := target.get_tree().current_scene
	if scene == null:
		return true
	var dialog := NodeUtils.get_child_of_type(scene, DialogController) as DialogController
	if dialog != null:
		dialog.try_action(SHOOT_ACTION)
	return true
