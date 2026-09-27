class_name SceneItemGlassEye
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.GLASS_EYE
	pickable = false
	ink_story_view = "res://Files/SceneDialogs/Ink/Preview/glass_eye.ink"
	interaction_type_overload[InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT] = SceneItemUI.INTERACTION_TYPE.LOOK

# SKIP GENERATION
