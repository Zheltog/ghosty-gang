extends Node2D

@export_file("*.ink") var story_path: String
@export var next_scene: SceneLoader.SCENE = SceneLoader.SCENE.NONE

@onready var _dialog: DialogController = $DialogController

func _ready() -> void:
	_dialog.story_finished.connect(_on_story_finished)
	if story_path.is_empty():
		printerr("DialogBackdrop: story_path is empty")
		return
	_dialog.start_story(story_path)

func _on_story_finished(_story_name: String) -> void:
	var exit_name := str(InkVariableStore.get_value("exit", "")).strip_edges()
	if not exit_name.is_empty():
		InkVariableStore.set_value("exit", "")
	var scene := SceneLoader.scene_from_exit(exit_name)
	if scene == SceneLoader.SCENE.NONE:
		scene = next_scene
	if scene == SceneLoader.SCENE.NONE:
		return
	SceneLoader.change_scene(scene)
