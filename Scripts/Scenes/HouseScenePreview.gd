class_name HouseScenePreview
extends HouseSceneBase

@onready var dialog_controller: DialogController = $DialogController
@onready var scene_object_manager: SceneObjectsManager = $SceneObjectManager

@export var ink_dialog_appear_path : String

var ghost: Node2D

func _ready() -> void:
	StateManager.clear_state()
	super._ready()
	ghost = get_node_or_null("Rooms/Kitchen/Ghost") as Node2D
	load_room("preroom")

func load_room(room_name: String) -> void:
	super.load_room(room_name)
	if scene_object_manager:
		scene_object_manager.update_mouse_cursor()

func engineer_appear() -> void:
	if characters.is_empty() or characters[0] == null:
		printerr("HouseScenePreview: no engineer character configured")
		return
	var engineer := characters[0]
	var characters_root := engineer.get_parent()
	if characters_root:
		characters_root.visible = true
	engineer.set_location("preroom")

func ghost_appear() -> void:
	if ghost:
		ghost.show()
	engineer_appear()
	if ink_dialog_appear_path.is_empty():
		printerr("HouseScenePreview: ink_dialog_appear_path is empty")
		return
	dialog_controller.start_story.call_deferred(ink_dialog_appear_path)
