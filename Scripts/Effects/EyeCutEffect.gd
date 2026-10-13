class_name EyeCutEffect
extends TextureRect

@export var speed := 1.0
@export var average_window := 0.1

@export var rise_speed := 12.0
@export var decay_speed := 3.0

var _prev_mouse_position: Vector2
var _mouse_speed: float
var _material : ShaderMaterial

var _time : float = 0.0

var minimum_pain_pos := Vector2(0.0, 0.0)
var _in_agony : bool = false

func _ready() -> void:
	_prev_mouse_position = get_global_mouse_position()
	_material = material as ShaderMaterial
	_in_agony = true
	#_material.set_shader_parameter("alpha", 0.0)

func stab() -> void:
	_material.set_shader_parameter("alpha", 1.0)

func _process(delta: float) -> void:
	update_mouse_speed(delta)
	var mouse_pos =  get_global_mouse_position()
	var swirl = (mouse_pos.x - minimum_pain_pos.x) / 1920
	var depth = 0.1 * (mouse_pos.y - minimum_pain_pos.y) / 1080 + 0.3
	var pain = clamp(_mouse_speed / 5000.0, 0.05, 0.4)
	#var agony_dist = minimum_pain_pos.distance_to(mouse_pos)
	#if agony_dist <= 100.0:
		#_in_agony = false
		#get_tree().create_timer(4.0).timeout.connect(resume_agony)
	#pain += agony_dist / 3000.0
	_material.set_shader_parameter("swirl", swirl)
	_material.set_shader_parameter("flow_depth", depth)
	_material.set_shader_parameter("pain_coef", pain)
	_material.set_shader_parameter("time", _time)
	_time -= delta * speed
	#if _in_agony:
		#speed += delta * 0.1
		#if speed >= 4.0:
			#print("die")
	#else:
		#speed -= delta * 6.0
	#speed = clamp(speed, 1.0, 4.0)
	#print(speed)

func resume_agony() -> void:
	_in_agony = true
	minimum_pain_pos = Vector2(randf_range(0.0, 1920.0), randf_range(0.0, 1080))

func update_mouse_speed(delta: float) -> void:
	var current_position := get_global_mouse_position()
	var velocity := (current_position - _prev_mouse_position) / delta
	_prev_mouse_position = current_position

	# Target value based on mouse movement.
	var target := velocity.length() * speed

	# Rise quickly, decay slowly.
	var smoothing := rise_speed if target > _mouse_speed else decay_speed
	_mouse_speed = lerpf(_mouse_speed, target, 1.0 - exp(-smoothing * delta))
