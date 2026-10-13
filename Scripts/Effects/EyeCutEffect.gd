class_name EyeCutEffect
extends TextureRect

@export var speed := 1.0
@export var average_window := 0.1

@export var rise_speed := 12.0
@export var decay_speed := 3.0

@export var eye_parallax_smoothing := 10.0
@export var eye_parallax_invert := true

@export var control_eye := true
@export var next_effect: EyeReleasedEffect

@export var needle_rise_time := 0.6
@export var needle_overshoot := 120.0
@export var crack_hold := 0.2
@export var red_rise_time := 0.25

@export var crack_sound: AudioStream = preload("res://Assets/Audio/Sounds/wood.mp3")
@export var break_sound: AudioStream = preload("res://Assets/Audio/Sounds/TV_punch.mp3")

const SCREEN_CENTER := Vector2(960.0, 540.0)

var _prev_mouse_position: Vector2
var _mouse_speed: float
var _eye_mouse := Vector2.ZERO
var _material : ShaderMaterial
var _sequence_running := false

var _time : float = 0.0

var minimum_pain_pos := Vector2(0.0, 0.0)
var _in_agony : bool = false

func _ready() -> void:
	_prev_mouse_position = get_global_mouse_position()
	_material = material as ShaderMaterial
	_in_agony = true
	#_material.set_shader_parameter("alpha", 0.0)

func stab() -> void:
	if _sequence_running:
		return
	_sequence_running = true
	_material.set_shader_parameter("alpha", 1.0)
	_material.set_shader_parameter("show_line", true)
	_material.set_shader_parameter("full_red_alpha", 0.0)
	await _raise_needle()
	if crack_hold > 0.0:
		await get_tree().create_timer(crack_hold).timeout
	_material.set_shader_parameter("show_line", false)
	_play_sound(break_sound)
	await get_tree().create_timer(0.2).timeout
	await _tween_shader("full_red_alpha", 0.0, 1.0, red_rise_time)
	_release_eye()

func _process(delta: float) -> void:
	update_mouse_speed(delta)
	_material.set_shader_parameter("time", _time)
	_time -= delta * speed
	if not control_eye:
		_material.set_shader_parameter("eye_mouse_offset", Vector2.ZERO)
		_material.set_shader_parameter("pain_coef", 0.0)
		return
	update_eye_mouse(delta)
	var pain = clamp(_mouse_speed / 5000.0, 0.05, 0.4)
	_material.set_shader_parameter("pain_coef", pain)
	_material.set_shader_parameter("eye_mouse_offset", _eye_mouse)

func move_needle() -> void:
	var needle: Vector2 = _material.get_shader_parameter("needle_center")
	var target1 := Vector2(200.0, 580.0)
	_play_sound(crack_sound)
	await _tween_shader("needle_center", needle, target1, needle_rise_time)
	await get_tree().create_timer(0.1).timeout
	var target2 := Vector2(350.0, 500.0)
	_play_sound(crack_sound)
	await _tween_shader("needle_center", target1, target2, needle_rise_time)
	await get_tree().create_timer(0.1).timeout
	_play_sound(crack_sound)
	await _tween_shader("needle_center", target2, needle, needle_rise_time)
	await get_tree().create_timer(0.1).timeout

func _raise_needle() -> void:
	var needle: Vector2 = _material.get_shader_parameter("needle_center")
	var target1 := Vector2(150.0, 640.0)
	_play_sound(crack_sound)
	await _tween_shader("needle_center", needle, target1, needle_rise_time)
	await get_tree().create_timer(0.5).timeout
	
	var target2 := Vector2(440.0, 780.0)
	_play_sound(crack_sound)
	await _tween_shader("needle_center", target1, target2, needle_rise_time)
	await get_tree().create_timer(0.5).timeout
	
	_play_sound(crack_sound)
	var target3 := Vector2(320.0, 50.0)
	await _tween_shader("needle_center", target2, target3, needle_rise_time)

func _release_eye() -> void:
	control_eye = false
	_material.set_shader_parameter("eye_mouse_offset", Vector2.ZERO)
	_material.set_shader_parameter("pain_coef", 0.0)
	if next_effect:
		next_effect.begin_from_red_peak(_time)
		visible = false
		return
	await _tween_shader("eye_center", _material.get_shader_parameter("eye_center"), SCREEN_CENTER, red_rise_time)
	await _tween_shader("full_red_alpha", 1.0, 0.0, red_rise_time)

func _tween_shader(param: String, from: Variant, to: Variant, duration: float) -> void:
	var tween := create_tween()
	tween.tween_method(func(value): _material.set_shader_parameter(param, value), from, to, duration)
	await tween.finished

func _play_sound(stream: AudioStream) -> void:
	if stream == null or stream.resource_path.is_empty():
		return
	var command := AudioSoundCommand.new()
	command.instant = true
	command.resource_name = stream.resource_path
	CommonAudioProcessor.process_sound(command)

func update_eye_mouse(delta: float) -> void:
	var view := get_viewport().get_visible_rect().size
	if view.x <= 0.0 or view.y <= 0.0:
		return
	var pos := get_viewport().get_mouse_position()
	var target := Vector2((pos.x / view.x) * 2.0 - 1.0, (pos.y / view.y) * 2.0 - 1.0)
	target = target.clamp(Vector2(-1, -1), Vector2(1, 1))
	if eye_parallax_invert:
		target = -target
	if eye_parallax_smoothing > 0.0:
		_eye_mouse = _eye_mouse.lerp(target, 1.0 - exp(-eye_parallax_smoothing * delta))
	else:
		_eye_mouse = target

func update_mouse_speed(delta: float) -> void:
	var current_position := get_global_mouse_position()
	var velocity := (current_position - _prev_mouse_position) / delta
	_prev_mouse_position = current_position

	# Target value based on mouse movement.
	var target := velocity.length() * speed

	# Rise quickly, decay slowly.
	var smoothing := rise_speed if target > _mouse_speed else decay_speed
	_mouse_speed = lerpf(_mouse_speed, target, 1.0 - exp(-smoothing * delta))
