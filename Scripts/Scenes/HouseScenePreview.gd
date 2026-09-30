class_name HouseScenePreview
extends HouseSceneBase

@onready var dialog_controller: DialogController = $DialogController
@onready var scene_object_manager: SceneObjectsManager = $SceneObjectManager

@export var ink_dialog_appear_path : String

var ghost: Node2D

func _ready() -> void:
	super._ready()
	ghost = get_node_or_null("Rooms/Kitchen/Ghost") as Node2D
	load_room("preroom")

func load_room(room_name: String) -> void:
	super.load_room(room_name)
	if scene_object_manager:
		scene_object_manager.update_mouse_cursor()

func engineer_appear() -> void:
	var engineer := characters[0]
	engineer.set_location("preroom")

func ghost_appear() -> void:
	if ghost:
		ghost.show()
	if ink_dialog_appear_path.is_empty():
		printerr("HouseScenePreview: ink_dialog_appear_path is empty")
		return
	dialog_controller.start_story.call_deferred(ink_dialog_appear_path)
