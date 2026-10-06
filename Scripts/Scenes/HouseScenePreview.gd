class_name HouseScenePreview
extends HouseSceneBase

@export var scene_states: SceneDialogManager
@onready var scene_object_manager: SceneObjectsManager = $SceneObjectManager
@onready var blackout: BlackoutEffect = $Blackout

func _ready() -> void:
	StateManager.clear_state()
	super._ready()
	lock_room("kitchen", _kitchen_blocked)
	load_room("preroom")
	CommonAudioProcessor.transition_music(SceneLoader.DAY_MUSIC)

func load_room(room_name: String) -> void:
	super.load_room(room_name)
	if current_room != room_name:
		return
	if scene_object_manager:
		scene_object_manager.update_mouse_cursor()
	_notify_states("room_" + room_name)

func set_room_child_visible(room_name: String, child_name: String, shown: bool) -> void:
	var node := room_child(room_name, child_name)
	if node is CanvasItem:
		(node as CanvasItem).visible = shown

func room_child(room_name: String, child_name: String) -> Node:
	var rooms := get_node_or_null(ROOMS_NODE_NAME)
	if rooms == null:
		return null
	for child in rooms.get_children():
		if child is RoomBase and (child as RoomBase).room_name == room_name:
			return child.get_node_or_null(child_name)
	return null

func effect_blackout() -> void:
	await blackout.effect_blackout()

func back_to_normal() -> void:
	await blackout.back_to_normal()

func _kitchen_blocked() -> void:
	_notify_states("kitchen_blocked")

func _notify_states(event: String) -> void:
	if scene_states == null:
		printerr("HouseScenePreview: scene_states is not set")
		return
	scene_states.process_event(event)
