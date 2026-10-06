class_name SceneDialogManager
extends Node

@export var dialog_controller: DialogController
@export var timer: GameTimer
@export var first_state: SceneDialogState

var current_active: SceneDialogState

func process_event(event: String) -> void:
	if current_active == null:
		return
	current_active.process_event(event)

func _ready() -> void:
	_assign_manager(self)
	InkFunctions.subscribe(self)
	if dialog_controller:
		dialog_controller.story_finished.connect(_on_story_finished)
	if first_state:
		first_state.activate.call_deferred()

func call_delayed(method: Callable, delay_sec: float) -> void:
	get_tree().create_timer(delay_sec).timeout.connect(method)

func _on_story_finished(story: String) -> void:
	process_event("story_" + story + "_finished")

func _assign_manager(node: Node) -> void:
	for child in node.get_children():
		if child is SceneDialogState:
			(child as SceneDialogState).scene_dialog_manager = self
		_assign_manager(child)

func flag(key: String) -> bool:
	return bool(InkVariableStore.get_value(key, false))
