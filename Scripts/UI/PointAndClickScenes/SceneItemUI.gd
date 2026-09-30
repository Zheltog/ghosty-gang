class_name SceneItemUI
extends Sprite2D

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
	if scene_item_id != SceneItemGenerator.SCENE_ITEM.NONE:
		_scene_item = SceneItemGenerator.generate(scene_item_id)
		_scene_item.ready(self)
		tree_exiting.connect(_on_tree_exiting, CONNECT_ONE_SHOT)
	Area2DUtils.setup_collision_from_sprite(self, _area_2d)
	_area_2d.input_event.connect(_on_input_event)
	release()

func _on_tree_exiting() -> void:
	if _scene_item == null:
		return
	InkFunctions.unsubscribe(_scene_item)
	_scene_item = null

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

func hide_self() -> void:
	hide()

func press_item() -> void:
	if _scene_item == null:
		return
	var press_result = _scene_item.press(_get_equipped_item())
	_scene_object_manager.process_press_result(press_result)

func get_effective_interaction_type() -> INTERACTION_TYPE:
	if _scene_item == null:
		return intercation_type
	var overload = _scene_item.get_interaction_overload(_get_equipped_item())
	if overload == null:
		return intercation_type
	return overload

func _get_equipped_item() -> InventoryItemUI:
	if _scene_object_manager == null or _scene_object_manager.inventory == null:
		return null
	var equipped := _scene_object_manager.inventory.equipped_item
	if equipped != null and not is_instance_valid(equipped):
		return null
	return equipped

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_scene_object_manager.item_pressed(self)
