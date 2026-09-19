class_name HouseScenePreview
extends HouseSceneBase

enum Room {
	LIVING_ROOM,
	KITCHEN,
}

@onready var dialog_controller: DialogController = $DialogController
@onready var ghost: Node2D = $Kitchen/Ghost
@onready var kitchen: Node2D = $Kitchen
@onready var living_room: Node2D = $LivingRoom
@onready var scene_object_manager: SceneObjectsManager = $SceneObjectManager

@export var ink_dialog_appear_path : String

var _ghost_appeared: bool = false
var _current_room: Room = Room.LIVING_ROOM

func _ready() -> void:
	super._ready()
	_apply_room(_current_room)

func ghost_appear() -> void:
	_ghost_appeared = true
	_sync_ghost_visibility()
	if ink_dialog_appear_path.is_empty():
		printerr("HouseScenePreview: ink_dialog_appear_path is empty")
		return
	dialog_controller.load_story(ink_dialog_appear_path)
	dialog_controller.start_story()

func change_room(room_name: String) -> void:
	var room := _parse_room(room_name)
	if room == _current_room:
		return
	_current_room = room
	_apply_room(room)

func _parse_room(room_name: String) -> Room:
	var normalized := room_name.strip_edges().to_lower().replace("-", "_").replace(" ", "_")
	match normalized:
		"kitchen":
			return Room.KITCHEN
		"living_room", "livingroom", "living":
			return Room.LIVING_ROOM
		_:
			printerr("HouseScenePreview: unknown room '%s'" % room_name)
			return _current_room

func _apply_room(room: Room) -> void:
	var is_kitchen := room == Room.KITCHEN
	_set_room_active(kitchen, is_kitchen)
	_set_room_active(living_room, not is_kitchen)
	_sync_ghost_visibility()
	if scene_object_manager:
		scene_object_manager.update_mouse_cursor()

func _sync_ghost_visibility() -> void:
	ghost.visible = _ghost_appeared

func _set_room_active(room: Node2D, active: bool) -> void:
	if room == null:
		return
	room.visible = active
	if scene_object_manager == null:
		return
	for item in scene_object_manager.scene_items:
		if item == null or not room.is_ancestor_of(item):
			continue
		var area := item.get_node_or_null("Area2D") as Area2D
		if area:
			area.monitoring = active
			area.monitorable = active
			area.input_pickable = active
