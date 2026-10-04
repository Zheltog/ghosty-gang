class_name SceneItemPassport
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.PASSPORT
	pickable = false
	equiped_immediately = false
	inventory_item = InventoryItemGenerator.INVENTORY_ITEM.PASSPORT
	ink_story_view = "res://Files/SceneDialogs/Ink/passport.ink"
	after_pickup = SceneItemBase.AFTER_PICKUP.DISAPPEAR
	interaction_type = SceneItemUI.INTERACTION_TYPE.TAKE

# SKIP GENERATION
