class_name DarknessEffect
extends Sprite2D

var _material: ShaderMaterial

func _ready() -> void:
	_material = material as ShaderMaterial

func _process(_delta: float) -> void:
	if _material == null:
		return
	_material.set_shader_parameter("mouse_pos", get_global_mouse_position())
	_material.set_shader_parameter("light_on", InventoryItemFlashlight.light_on)
