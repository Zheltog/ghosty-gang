class_name EyeReleasedEffect
extends TextureRect

const SHADER_SIZE := Vector2(1920.0, 1080.0)
const SCREEN_CENTER := SHADER_SIZE * 0.5

@export var hold_time := 1.5
@export var fade_time := 1.0
@export var mouse_vector_scale := 0.2
@export var blink_interval := 14.0
@export var blink_duration := 0.22
@export var wander_radius := 120.0
@export var wander_pause := 5.0
@export var wander_move_time := 1.2

var _material: ShaderMaterial
var _default_eye_position := Vector2(300.0, 540.0)
var _eye_vector := Vector2.ZERO
var _wander_from := Vector2.ZERO
var _wander_to := Vector2.ZERO
var _wander_move_left := 0.0
var _wander_pause_left := 0.0
var _wandering := false
var _blink_wait := 0.0
var _blink_time := -1.0

func _ready() -> void:
	_material = material as ShaderMaterial
	#visible = false
	if _material == null:
		return
	var center: Variant = _material.get_shader_parameter("eye_center")
	if center is Vector2:
		_default_eye_position = center
	_wander_pause_left = wander_pause
	_blink_wait = blink_interval

func set_ghost_eye_position(position: Vector2) -> void:
	_eye_vector = position - _default_eye_position
	_apply_eye_offset()

func set_blink(amount: float) -> void:
	if _material == null:
		return
	_material.set_shader_parameter("blink", clampf(amount, 0.0, 1.0))

func begin_from_red_peak(_flow_time: float = 0.0) -> void:
	visible = true
	set_blink(1.0)
	_material.set_shader_parameter("alpha", 1.0)
	_set_red(1.0)
	var tween := create_tween()
	if hold_time > 0.0:
		tween.tween_interval(hold_time)
	tween.tween_method(_set_red, 1.0, 0.0, fade_time)

func _process(delta: float) -> void:
	if _material == null:
		return
	_update_wander(delta)
	_update_blink(delta)
	_apply_eye_offset()

func _update_wander(delta: float) -> void:
	if _wandering:
		_wander_move_left -= delta
		var duration := maxf(wander_move_time, 0.0001)
		var t := clampf(1.0 - _wander_move_left / duration, 0.0, 1.0)
		t = t * t * (3.0 - 2.0 * t)
		_eye_vector = _wander_from.lerp(_wander_to, t)
		if _wander_move_left > 0.0:
			return
		_eye_vector = _wander_to
		_wandering = false
		_wander_pause_left = wander_pause
		return
	_wander_pause_left -= delta
	if _wander_pause_left > 0.0:
		return
	_wander_from = _eye_vector
	_wander_to = _random_eye_vector()
	_wander_move_left = wander_move_time
	_wandering = true

func _update_blink(delta: float) -> void:
	if _blink_time >= 0.0:
		_blink_time += delta
		var duration := maxf(blink_duration, 0.0001)
		var t := clampf(_blink_time / duration, 0.0, 1.0)
		set_blink(_blink_curve(t))
		if t < 1.0:
			return
		set_blink(0.0)
		_blink_time = -1.0
		_blink_wait = blink_interval
		return
	_blink_wait -= delta
	if _blink_wait > 0.0:
		return
	_blink_time = 0.0

func _blink_curve(t: float) -> float:
	if t <= 0.5:
		var u := t / 0.5
		return u * u * (3.0 - 2.0 * u)
	var u := (t - 0.5) / 0.5
	return 1.0 - u * u * (3.0 - 2.0 * u)

func _random_eye_vector() -> Vector2:
	var angle := randf() * TAU
	var distance := sqrt(randf()) * wander_radius
	return Vector2(cos(angle), sin(angle)) * distance

func _apply_eye_offset() -> void:
	var mouse_vector := (_mouse_in_shader_space() - SCREEN_CENTER) * mouse_vector_scale
	var aberration := _eye_vector - mouse_vector
	_material.set_shader_parameter("eye_center", _default_eye_position + _eye_vector)
	_material.set_shader_parameter("abberation_vec", aberration * 0.1)

func _mouse_in_shader_space() -> Vector2:
	var view := get_viewport().get_visible_rect().size
	if view.x <= 0.0 or view.y <= 0.0:
		return SHADER_SIZE * 0.5
	var mouse := get_viewport().get_mouse_position()
	return Vector2(mouse.x / view.x, mouse.y / view.y) * SHADER_SIZE

func _set_red(value: float) -> void:
	_material.set_shader_parameter("full_red_alpha", value)
