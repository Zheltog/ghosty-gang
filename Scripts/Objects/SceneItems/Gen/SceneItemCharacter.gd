class_name SceneItemCharacter
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.CHARACTER
	pickable = false
	interaction_overload[InventoryItemGenerator.INVENTORY_ITEM.GUN] = {"interaction_type": SceneItemUI.INTERACTION_TYPE.SHOOT}

# SKIP GENERATION
