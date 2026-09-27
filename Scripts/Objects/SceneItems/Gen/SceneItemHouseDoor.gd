class_name SceneItemHouseDoor
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.HOUSE_DOOR
	pickable = false
	ink_story_view = "res://Files/SceneDialogs/Ink/door_preview.ink"

# SKIP GENERATION
