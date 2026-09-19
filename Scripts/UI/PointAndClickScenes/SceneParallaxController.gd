class_name SceneParallaxController
extends Node

@export var enabled: bool = true
@export var smoothing: float = 10.0
@export var invert: bool = true

var _mouse: Vector2 = Vector2.ZERO
var _components: Array[ParallaxComponent] = []

func _ready() -> void:
	var stack: Array[Node] = [get_parent()]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		if node is ParallaxComponent:
			_components.append(node)
		for child in node.get_children():
			stack.append(child)

func _process(delta: float) -> void:
	if not enabled:
		return
	var view := get_viewport().get_visible_rect().size
	var pos := get_viewport().get_mouse_position()
	var target := Vector2((pos.x / view.x) * 2.0 - 1.0, (pos.y / view.y) * 2.0 - 1.0)
	target = target.clamp(Vector2(-1, -1), Vector2(1, 1))
	if invert:
		target = -target
	if smoothing > 0.0:
		_mouse = _mouse.lerp(target, 1.0 - exp(-smoothing * delta))
	else:
		_mouse = target
	for component in _components:
		if component:
			component.apply_mouse(_mouse)
