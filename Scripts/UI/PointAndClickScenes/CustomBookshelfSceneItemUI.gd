class_name CustomBookshelfSceneItemUI
extends CustomSceneItemUIBase

const STATE_KEY_TURNED := "key_turned"
const STATE_OPEN := "bookshelf_open"
const STATE_LOCKED := "bookshelf_locked"
const STATE_BOOK_REMOVED := "bookshelf_book_removed"
const KEY_TURN_SOUND := "res://Assets/Audio/Sounds/key_turning.mp3"
const SHELF_MOVE_SOUND := "res://Assets/Audio/Sounds/shelf_move.mp3"
const MOVED_BACKGROUND := preload("res://Assets/Sprites/Backgrounds/bookcase_2_normal.png")
const REMOVED_CLOSED_BACKGROUND := preload("res://Assets/Sprites/Backgrounds/bookcase_1_removed_book_closed.png")
const REMOVED_OPEN_BACKGROUND := preload("res://Assets/Sprites/Backgrounds/bookcase_1_removed_book_open.png")
const MOVED_LIGHT_INDEX := 5
const REMOVED_CLOSED_LIGHT_INDEX := 17
const REMOVED_OPEN_LIGHT_INDEX := 18
const LIVING_CLOSED_BACKGROUND := preload("res://Assets/Sprites/Backgrounds/hall_1_normal.png")
const LIVING_OPEN_BACKGROUND := preload("res://Assets/Sprites/Backgrounds/hall_1b_normal.png")
const LIVING_CLOSED_LIGHT_INDEX := 12
const LIVING_OPEN_LIGHT_INDEX := 0

var _closed_background: Texture2D
var _closed_light_index := 4

func _ready() -> void:
	scene_item_id = SceneItemGenerator.SCENE_ITEM.NONE
	super._ready()
	InkFunctions.subscribe(self)
	var background := _background()
	if background != null:
		_closed_background = background.texture
		var index: Variant = background.get_instance_shader_parameter("lighted_index")
		if index != null:
			_closed_light_index = int(index)
	var open := bool(StateManager.get_state(STATE_OPEN, false))
	_apply_open(open)
	if bool(StateManager.get_state(STATE_BOOK_REMOVED, false)):
		_show_keyhole()
	if open or bool(StateManager.get_state(STATE_KEY_TURNED, false)):
		_disable_books()

func on_book_removed() -> void:
	StateManager.set_state(STATE_BOOK_REMOVED, true)
	_show_keyhole()
	_show_background(bool(StateManager.get_state(STATE_OPEN, false)))

func turn_key() -> void:
	StateManager.set_state(STATE_KEY_TURNED, true)
	_remove_keyhole()
	_disable_books()
	_play_sound(KEY_TURN_SOUND)

func open_shelf() -> void:
	if _is_locked():
		return
	StateManager.set_state(STATE_OPEN, true)
	_apply_open(true)
	_disable_books()
	_play_sound(SHELF_MOVE_SOUND)
	_start_storage_hum()

func close_shelf() -> void:
	StateManager.set_state(STATE_OPEN, false)
	_apply_open(false)
	_play_sound(SHELF_MOVE_SOUND)

func lock_closed() -> void:
	StateManager.set_state(STATE_LOCKED, true)
	close_shelf()

func _start_storage_hum() -> void:
	var house := HouseSceneBase.current_house_scene as HouseScenePreview
	if house == null or house.scene_states == null:
		return
	house.scene_states.process_event("storage_opened")

func _play_sound(resource_name: String) -> void:
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = resource_name
	CommonAudioProcessor.process_sound(command)

func press_item() -> void:
	if _is_locked():
		return
	if not bool(StateManager.get_state(STATE_KEY_TURNED, false)):
		return
	var open := not bool(StateManager.get_state(STATE_OPEN, false))
	StateManager.set_state(STATE_OPEN, open)
	_apply_open(open)
	_play_sound(SHELF_MOVE_SOUND)
	if open:
		_start_storage_hum()

func _apply_open(open: bool) -> void:
	_show_background(open)
	_use_moved_area(open)
	_set_storage_path(open)
	_update_living_room_background(open)

func get_effective_interaction_type() -> INTERACTION_TYPE:
	if _is_locked() or not bool(StateManager.get_state(STATE_KEY_TURNED, false)):
		return INTERACTION_TYPE.NONE
	return INTERACTION_TYPE.TAKE

func _is_locked() -> bool:
	return bool(StateManager.get_state(STATE_LOCKED, false))

func _use_moved_area(moved: bool) -> void:
	var after := get_node_or_null("Area2DAfterMove") as Area2D
	_set_area_enabled(_area_2d, not moved)
	if after == null:
		return
	if not after.input_event.is_connected(_on_input_event):
		after.input_event.connect(_on_input_event)
	_set_area_enabled(after, moved)

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
	if room == null:
		return
	var path := room.get_node_or_null("ToStorage")
	if path:
		path.visible = open

func _show_keyhole() -> void:
	if bool(StateManager.get_state(STATE_KEY_TURNED, false)):
		return
	var keyhole := get_node_or_null("Keyhole")
	if keyhole:
		keyhole.show()

func _remove_keyhole() -> void:
	var keyhole := get_node_or_null("Keyhole")
	if keyhole == null:
		return
	keyhole.hide()
	keyhole.queue_free()

func _book_removed() -> bool:
	return bool(StateManager.get_state(STATE_BOOK_REMOVED, false))

func _show_background(open: bool) -> void:
	var background := _background()
	if background == null:
		return
	var removed := _book_removed()
	if open and removed:
		background.texture = REMOVED_OPEN_BACKGROUND
		background.set_instance_shader_parameter("lighted_index", REMOVED_OPEN_LIGHT_INDEX)
	elif open:
		background.texture = MOVED_BACKGROUND
		background.set_instance_shader_parameter("lighted_index", MOVED_LIGHT_INDEX)
	elif removed:
		background.texture = REMOVED_CLOSED_BACKGROUND
		background.set_instance_shader_parameter("lighted_index", REMOVED_CLOSED_LIGHT_INDEX)
	else:
		background.texture = _closed_background
		background.set_instance_shader_parameter("lighted_index", _closed_light_index)

func _background() -> Sprite2D:
	var room := get_parent()
	if room == null:
		return null
	return room.get_node_or_null("Background") as Sprite2D

func _update_living_room_background(open: bool) -> void:
	var house := HouseSceneBase.current_house_scene
	if house == null:
		return
	var rooms := house.get_node_or_null(HouseSceneBase.ROOMS_NODE_NAME)
	if rooms == null:
		return
	for child in rooms.get_children():
		if not child is RoomBase or (child as RoomBase).room_name != "living_room":
			continue
		var background := child.get_node_or_null("Background") as Sprite2D
		if background == null:
			return
		if open:
			background.texture = LIVING_OPEN_BACKGROUND
			background.set_instance_shader_parameter("lighted_index", LIVING_OPEN_LIGHT_INDEX)
		else:
			background.texture = LIVING_CLOSED_BACKGROUND
			background.set_instance_shader_parameter("lighted_index", LIVING_CLOSED_LIGHT_INDEX)
		return
