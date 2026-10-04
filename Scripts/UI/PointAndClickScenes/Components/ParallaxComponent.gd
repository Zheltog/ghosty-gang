class_name ParallaxComponent
extends Node

@export var camera_distance: float = 10.0

var rest_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	var parent := get_parent() as Node2D
	if parent == null:
		printerr("ParallaxComponent: parent must be a Node2D")
		return
	rest_position = parent.position

func apply_mouse(mouse: Vector2) -> void:
	var parent := get_parent() as Node2D
	if parent == null:
		return
	parent.position = rest_position + mouse * camera_distance
