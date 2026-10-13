class_name ParallaxComponent
extends Node

@export var camera_distance: float = 10.0

var rest_position: Vector2 = Vector2.ZERO
var parent

func _ready() -> void:
	parent = get_parent()
	if (parent as Node2D == null) and (parent as Control == null):
		printerr("ParallaxComponent: parent must be a Node2D or a Control")
		parent = null
		return
	rest_position = parent.position

func apply_mouse(mouse: Vector2) -> void:
	if parent == null:
		return
	parent.position = rest_position + mouse * camera_distance
