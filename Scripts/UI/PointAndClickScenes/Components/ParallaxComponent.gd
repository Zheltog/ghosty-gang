class_name ParallaxComponent
extends Node

@export var camera_distance: float = 10.0

var rest_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	var parent := get_parent()
	if parent is Node2D:
		rest_position = (parent as Node2D).position
	elif parent is Control:
		rest_position = (parent as Control).position
	else:
		printerr("ParallaxComponent: parent must be a Node2D or Control")

func apply_mouse(mouse: Vector2) -> void:
	var parent := get_parent()
	if parent is Node2D:
		(parent as Node2D).position = rest_position + mouse * camera_distance
	elif parent is Control:
		(parent as Control).position = rest_position + mouse * camera_distance
