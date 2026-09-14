class_name SceneItemDoor
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.DOOR
	pickable = false
	ink_story_view = "res://Files/SceneDialogs/Ink/door_preview.ink"

# SKIP GENERATION

func enter_house() -> void:
	SceneLoader.change_scene(SceneLoader.SCENE.INSIDE_HOUSE)
