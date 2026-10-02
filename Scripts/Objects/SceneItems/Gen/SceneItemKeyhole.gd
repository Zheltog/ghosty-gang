class_name SceneItemKeyhole
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.KEYHOLE
	pickable = false
	ink_story_view = "res://Files/SceneDialogs/Ink/keyhole.ink"
	interaction_type = SceneItemUI.INTERACTION_TYPE.LOOK
	interaction_overload[InventoryItemGenerator.INVENTORY_ITEM.KEY_BOOKSHELF] = {"interaction_type": SceneItemUI.INTERACTION_TYPE.TAKE, "ink_story_view": "res://Files/SceneDialogs/Ink/keyhole_unlock.ink"}

# SKIP GENERATION
