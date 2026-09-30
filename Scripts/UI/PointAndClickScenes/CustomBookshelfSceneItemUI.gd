class_name CustomBookshelfSceneItemUI
extends CustomSceneItemUIBase

const STATE_KEY_TURNED := "key_turned"
const STATE_OPEN := "bookshelf_open"

@export var open_offset: Vector2 = Vector2(-640, 0)
@export var move_duration: float = 0.45

var _closed_position: Vector2
var _moving := false

func _ready() -> void:
	scene_item_id = SceneItemGenerator.SCENE_ITEM.NONE
	super._ready()
	InkFunctions.subscribe(self)
	_closed_position = position
	if bool(StateManager.get_state(STATE_OPEN, false)):
		_set_rest(_closed_position + open_offset)

func turn_key() -> void:
	StateManager.set_state(STATE_KEY_TURNED, true)

func press_item() -> void:
	if _moving or not bool(StateManager.get_state(STATE_KEY_TURNED, false)):
		return
	var open := not bool(StateManager.get_state(STATE_OPEN, false))
	StateManager.set_state(STATE_OPEN, open)
	var target := _closed_position + open_offset if open else _closed_position
	_move_to(target)

func get_effective_interaction_type() -> INTERACTION_TYPE:
	if _moving or not bool(StateManager.get_state(STATE_KEY_TURNED, false)):
		return INTERACTION_TYPE.NONE
	return INTERACTION_TYPE.TAKE

func _move_to(target: Vector2) -> void:
	_moving = true
	var parallax := get_node_or_null("ParallaxComponent") as ParallaxComponent
	var from := parallax.rest_position if parallax else position
	var tween := create_tween()
	tween.tween_method(_set_rest, from, target, move_duration)
	tween.finished.connect(func() -> void: _moving = false)

func _set_rest(value: Vector2) -> void:
	var parallax := get_node_or_null("ParallaxComponent") as ParallaxComponent
	if parallax:
		parallax.rest_position = value
	position = value
