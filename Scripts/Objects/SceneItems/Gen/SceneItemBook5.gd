class_name SceneItemBook5
extends SceneItemBase

func _init() -> void:
	item = SceneItemGenerator.SCENE_ITEM.BOOK_5
	pickable = false
	ink_story_view = "res://Files/SceneDialogs/Ink/book_5.ink"

# SKIP GENERATION

func reveal_keyhole() -> void:
	if _host == null:
		return
	var shelf := _host.get_parent()
	if shelf == null:
		return
	var keyhole := shelf.get_node_or_null("Keyhole")
	if keyhole:
		keyhole.show()
	_host.hide_self()
