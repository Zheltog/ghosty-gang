class_name SceneItemUI
extends Node2D

enum TRIGGER_TYPE {
	HOLD,
	PRESS
}

enum INTERACTION_TYPE {
	LOOK,
	TAKE,
	NONE
}

@export var scene_item_id : SceneItemGenerator.SCENE_ITEM
@export_category("Interaction Settings")
@export var trigger_type : TRIGGER_TYPE = TRIGGER_TYPE.PRESS
@export var intercation_type : INTERACTION_TYPE = INTERACTION_TYPE.NONE
# only used if trigger_type is hold
@export var hold_time : float = 1.0
@export var remove_progress_on_release : bool = true

@onready var _area_2d: Area2D = $Area2D

var _scene_item : SceneItemBase
var _scene_object_manager : SceneObjectsManager
func set_scene_object_manager(scene_object_manager : SceneObjectsManager) -> void:
	_scene_object_manager = scene_object_manager

var _pickup_progress : float = 0.0
func get_pickup_time() -> float:
	return _scene_item.pickup_time

func _ready() -> void:
	_scene_item = SceneItemGenerator.generate(scene_item_id)
	_area_2d.mouse_entered.connect(_on_mouse_entered)
	_area_2d.mouse_exited.connect(_on_mouse_exited)
	_area_2d.input_event.connect(_on_input_event)
	release()

var _pressed : bool = false

func _process(delta : float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		release()
		return
	if _pressed:
		_pickup_progress += delta
		if _pickup_progress > hold_time:
			press_item()
		update_hold_animation()

func update_hold_animation() -> void:
	#TODO:
	print(_pickup_progress)

func press_ui() -> void:
	match trigger_type:
		TRIGGER_TYPE.PRESS:
			press_item()
		TRIGGER_TYPE.HOLD:
			_pressed = true
			set_process(true)

func release() -> void:
	_pressed = false
	if remove_progress_on_release:
		_pickup_progress = 0.0
	set_process(false)

func press_item() -> void:
	#TODO: pass currently equiped item to press
	var press_result = _scene_item.press()
	_scene_object_manager.process_press_result(press_result)

func _on_mouse_entered() -> void:
	_scene_object_manager.highlight_item(self)

func _on_mouse_exited() -> void:
	if _pressed:
		release()
	_scene_object_manager.unhighlight_item(self)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_scene_object_manager.item_pressed(self)
