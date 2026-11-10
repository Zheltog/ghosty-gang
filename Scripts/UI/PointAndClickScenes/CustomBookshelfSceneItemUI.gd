class_name CustomBookshelfSceneItemUI
extends CustomSceneItemUIBase

const STATE_KEY_TURNED := "key_turned"
const STATE_OPEN := "bookshelf_open"
const STATE_LOCKED := "bookshelf_locked"
const STATE_BOOK_REMOVED := "bookshelf_book_removed"
const _SHELF_TEX: Array[Texture2D] = [
	preload("res://Assets/Sprites/Backgrounds/bookcase_1_removed_book_closed.png"),
	preload("res://Assets/Sprites/Backgrounds/bookcase_2_normal.png"),
	preload("res://Assets/Sprites/Backgrounds/bookcase_1_removed_book_open.png"),
]
const _SHELF_LIGHT := [1, 12, 2]
const _LIVING_TEX: Array[Texture2D] = [
	preload("res://Assets/Sprites/Backgrounds/hall_1_normal.png"),
	preload("res://Assets/Sprites/Backgrounds/hall_1b_normal.png"),
]
const _LIVING_LIGHT := [7, 6]
const _MOVED_OUTLINE := "res://Assets/Sprites/SceneItems/Outlines/Bookshelf_Shelfs_moved.png"

var _closed_background: Texture2D
var _closed_light_index := 0
var _rest_outline: Texture2D

func _ready() -> void:
	_rest_outline = texture
	scene_item_id = SceneItemGenerator.SCENE_ITEM.NONE
	super._ready()
	InkFunctions.subscribe(self)
	var background := _background()
	if background:
		_closed_background = background.texture
		var index: Variant = background.get_instance_shader_parameter("lighted_index")
		if index != null:
			_closed_light_index = int(index)
	_apply_open(_flag(STATE_OPEN))
	if _flag(STATE_BOOK_REMOVED):
		_show_keyhole()
	if _flag(STATE_OPEN) or _flag(STATE_KEY_TURNED):
		_disable_books()

func on_book_removed() -> void:
	StateManager.set_state(STATE_BOOK_REMOVED, true)
	_show_keyhole()
	_show_background(_flag(STATE_OPEN))

func turn_key() -> void:
	StateManager.set_state(STATE_KEY_TURNED, true)
	_remove_keyhole()
	_disable_books()
	_play("res://Assets/Audio/Sounds/key_turning.mp3")

func open_shelf() -> void:
	if not _flag(STATE_LOCKED):
		_set_open(true)

func close_shelf() -> void:
	_set_open(false)

func lock_closed() -> void:
	StateManager.set_state(STATE_LOCKED, true)
	close_shelf()

func press_item() -> void:
	if _flag(STATE_LOCKED) or not _flag(STATE_KEY_TURNED):
		return
	_set_open(not _flag(STATE_OPEN))

func get_effective_interaction_type() -> INTERACTION_TYPE:
	if _flag(STATE_LOCKED) or not _flag(STATE_KEY_TURNED):
		return INTERACTION_TYPE.NONE
	return INTERACTION_TYPE.TAKE

func _set_open(open: bool) -> void:
	StateManager.set_state(STATE_OPEN, open)
	_apply_open(open)
	_play("res://Assets/Audio/Sounds/shelf_move.mp3")
	if open:
		_disable_books()
		_hum()

func _apply_open(open: bool) -> void:
	_show_background(open)
	_use_moved_area(open)
	_set_storage_path(open)
	_update_living_room(open)

func _flag(key: String) -> bool:
	return bool(StateManager.get_state(key, false))

func _play(path: String) -> void:
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = path
	CommonAudioProcessor.process_sound(command)

func _hum() -> void:
	var house := HouseSceneBase.current_house_scene as HouseScenePreview
	if house and house.scene_states:
		house.scene_states.process_event("storage_opened")

func _use_moved_area(moved: bool) -> void:
	var after := get_node_or_null("Area2DAfterMove") as Area2D
	_set_area_enabled(_area_2d, not moved)
	if after == null:
		return
	if not after.input_event.is_connected(_on_input_event):
		after.input_event.connect(_on_input_event)
	_set_area_enabled(after, moved)
	if _rest_outline:
		texture = load(_MOVED_OUTLINE) if moved else _rest_outline

func _disable_books() -> void:
	for child in get_children():
		if not str(child.name).begins_with("Books"):
			continue
		var area := child.get_node_or_null("Area2D") as Area2D
		if area:
			_set_area_enabled(area, false)

func _set_area_enabled(area: Area2D, enabled: bool) -> void:
	area.input_pickable = enabled
	area.monitoring = enabled
	area.monitorable = enabled
	for child in area.get_children():
		if child is CollisionPolygon2D or child is CollisionShape2D:
			child.disabled = not enabled

func _set_storage_path(open: bool) -> void:
	var room := get_parent()
	var path := room.get_node_or_null("ToStorage") if room else null
	if path:
		path.visible = open

func _show_keyhole() -> void:
	if _flag(STATE_KEY_TURNED):
		return
	var keyhole := get_node_or_null("Keyhole")
	if keyhole:
		keyhole.show()

func _remove_keyhole() -> void:
	var keyhole := get_node_or_null("Keyhole")
	if keyhole:
		keyhole.hide()
		keyhole.queue_free()

func _show_background(open: bool) -> void:
	var background := _background()
	if background == null:
		return
	var removed := _flag(STATE_BOOK_REMOVED)
	if not open and not removed:
		_paint(background, _closed_background, _closed_light_index)
		return
	var slot := (2 if removed else 1) if open else 0
	_paint(background, _SHELF_TEX[slot], int(_SHELF_LIGHT[slot]))

func _update_living_room(open: bool) -> void:
	var house := HouseSceneBase.current_house_scene as HouseScenePreview
	if house == null:
		return
	var background := house.room_child("living_room", "Background") as Sprite2D
	if background:
		_paint(background, _LIVING_TEX[int(open)], int(_LIVING_LIGHT[int(open)]))
	house.set_room_child_visible("living_room", "ToBookshelf", not open)
	house.set_room_child_visible("living_room", "ToBookshelfOpen", open)

func _paint(sprite: Sprite2D, tex: Texture2D, index: int) -> void:
	sprite.texture = tex
	sprite.set_instance_shader_parameter("lighted_index", index)

func _background() -> Sprite2D:
	var room := get_parent()
	return room.get_node_or_null("Background") as Sprite2D if room else null
