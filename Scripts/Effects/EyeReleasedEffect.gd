class_name EyeReleasedEffect
extends TextureRect

@export var hold_time := 1.5
@export var fade_time := 1.0
@export var pulse_speed := 3.0

var _material: ShaderMaterial
var _pulse := 0.0

func _ready() -> void:
	_material = material as ShaderMaterial
	visible = false

func begin_from_red_peak(_flow_time: float = 0.0) -> void:
	visible = true
	_set_red(1.0)
	var tween := create_tween()
	if hold_time > 0.0:
		tween.tween_interval(hold_time)
	tween.tween_method(_set_red, 1.0, 0.0, fade_time)

func _process(delta: float) -> void:
	if not visible or _material == null:
		return
	_pulse += delta * pulse_speed
	_material.set_shader_parameter("pulse", _pulse)

func _set_red(value: float) -> void:
	_material.set_shader_parameter("full_red_alpha", value)
