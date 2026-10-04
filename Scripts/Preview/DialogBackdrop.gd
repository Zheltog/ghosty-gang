extends Node2D

const FADE_SECONDS := 1.1

@export_file("*.ink") var story_path: String
@export var next_scene: SceneLoader.SCENE = SceneLoader.SCENE.NONE
## When set, the day checkpoint is written before the scene changes.
@export var day_number: int = 0
@export var fade_in_before_story: bool = false

@onready var _dialog: DialogController = $DialogController

func _ready() -> void:
	_dialog.story_finished.connect(_on_story_finished)
	if fade_in_before_story:
		await fade_from_black()
		if not is_inside_tree():
			return
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
	if day_number > 0:
		SceneLoader.start_day(day_number, scene)
		return
	SceneLoader.change_scene(scene)

func fade_to_black() -> void:
	await _tween_fade(1.0)

func fade_from_black() -> void:
	await _tween_fade(0.0)

func _tween_fade(target_alpha: float) -> void:
	var rect := get_node_or_null("FadeLayer/Fade") as ColorRect
	if rect == null:
		return
	rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(rect, "color:a", target_alpha, FADE_SECONDS)
	await tween.finished
	if not is_inside_tree():
		return
	if target_alpha <= 0.0:
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
