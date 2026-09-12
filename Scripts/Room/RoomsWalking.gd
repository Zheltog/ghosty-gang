class_name RoomsWalking

extends CanvasLayer

# test
@export var rooms: Array[Dictionary]

@onready var _content: Control = $Content
@onready var _buttons: Control = $Buttons
@onready var _button_forward: TextureButton = $Buttons/ButtonUp
@onready var _button_back: TextureButton = $Buttons/ButtonDown
@onready var _button_left: TextureButton = $Buttons/ButtonLeft
@onready var _button_right: TextureButton = $Buttons/ButtonRight

var _current_room_id: String
var _rooms: Dictionary
var _content_children: Dictionary = {}

func _ready() -> void:
	_button_forward.pressed.connect(func(): _move_to(Direction.FORWARD))
	_button_back.pressed.connect(func(): _move_to(Direction.BACKWARD))
	_button_left.pressed.connect(func(): _move_to(Direction.LEFTWARD))
	_button_right.pressed.connect(func(): _move_to(Direction.RIGHTWARD))
	set_rooms(rooms, "entrance")

func show_buttons() -> void:
	if not _buttons.visible:
		_buttons.show()

func hide_buttons() -> void:
	if _buttons.visible:
		_buttons.hide()

func set_rooms(room_dictionaries: Array, initial_room_id: String) -> void:
	_current_room_id = initial_room_id
	_rooms = {}
	for room_dictionary in room_dictionaries:
		var room = RoomDescriptor.new(room_dictionary)
		if room.id == null or room.id == "":
			printerr("[RoomWalking] Room id should be specified")
			return
		_rooms[room.id] = room
	if not _rooms.has(_current_room_id):
		printerr("[RoomWalking] Initial room id is not specified in list")
		return
	_set_content(_rooms[_current_room_id].content_scene_name)
	_update_buttons()

func _move_to(direction: Direction) -> void:
	var current_room = _rooms[_current_room_id]
	var next_room_id: String
	match direction:
		Direction.FORWARD:
			next_room_id = current_room.forward_id
		Direction.BACKWARD:
			next_room_id = current_room.back_id
		Direction.LEFTWARD:
			next_room_id = current_room.left_id
		Direction.RIGHTWARD:
			next_room_id = current_room.right_id
	if next_room_id == null or next_room_id == "":
		printerr("[RoomWalking] No next room id specified for room ", _current_room_id, " and direction ", direction)
		return
	if not _rooms.has(next_room_id):
		printerr("[RoomWalking] Unknown room ", next_room_id)
		return
	_current_room_id = next_room_id
	_set_content(_rooms[_current_room_id].content_scene_name)
	_update_buttons()

func _update_buttons() -> void:
	show_buttons()
	var current_room = _rooms[_current_room_id]
	var is_forward_id_provided = current_room.forward_id != null and current_room.forward_id != ""
	var is_back_id_provided = current_room.back_id != null and current_room.back_id != ""
	var is_left_id_provided = current_room.left_id != null and current_room.left_id != ""
	var is_right_id_provided = current_room.right_id != null and current_room.right_id != ""
	if not is_forward_id_provided and _button_forward.visible:
		_button_forward.hide()
	if not is_back_id_provided and _button_back.visible:
		_button_back.hide()
	if not is_right_id_provided and _button_left.visible:
		_button_left.hide()
	if current_room.right_id == null or current_room.right_id == "" and _button_right.visible:
		_button_right.hide()
	if is_forward_id_provided and not _button_forward.visible:
		_button_forward.show()
	if is_back_id_provided and not _button_back.visible:
		_button_back.show()
	if is_left_id_provided and not _button_left.visible:
		_button_left.show()
	if is_right_id_provided and not _button_right.visible:
		_button_right.show()

func _set_content(content_scene_name: String) -> void:
	if content_scene_name == null or content_scene_name == "":
		printerr("[RoomWalking] No content scene name provided")
		return
	if not _content_children.has(content_scene_name):
		var content_scene = load(content_scene_name)
		if content_scene == null:
			printerr("[RoomWalking] No content scene found by name ", content_scene_name)
			return
		var content_instance = content_scene.instantiate()
		_content.add_child(content_instance)
		_content_children[content_scene_name] = content_instance
	for child_name in _content_children.keys():
		if child_name != content_scene_name and _content_children[child_name].visible:
			_content_children[child_name].hide()
		elif child_name == content_scene_name and not _content_children[child_name].visible:
			_content_children[child_name].show()

enum Direction { FORWARD, BACKWARD, LEFTWARD, RIGHTWARD }
