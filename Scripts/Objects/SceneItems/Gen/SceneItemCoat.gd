class_name SceneItemCoat
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.COAT
	pickable = false
	ink_story_view = "res://Files/SceneDialogs/Ink/coat.ink"
	interaction_type = SceneItemUI.INTERACTION_TYPE.LOOK

# SKIP GENERATION
