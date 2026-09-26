class_name HouseScenePreview
extends HouseSceneBase

@onready var dialog_controller: DialogController = $DialogController
@onready var ghost: Node2D = $Rooms/Kitchen/Ghost
@onready var scene_object_manager: SceneObjectsManager = $SceneObjectManager

@export var ink_dialog_appear_path : String

func _ready() -> void:
	super._ready()
	load_room("living_room")

func load_room(room_name: String) -> void:
	super.load_room(room_name)
	if scene_object_manager:
		scene_object_manager.update_mouse_cursor()

func ghost_appear() -> void:
	ghost.show()
	if ink_dialog_appear_path.is_empty():
		printerr("HouseScenePreview: ink_dialog_appear_path is empty")
		return
	dialog_controller.start_story.call_deferred(ink_dialog_appear_path)
