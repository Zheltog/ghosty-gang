class_name MapPoint

extends Node

@export var id: String
## If not NONE, left-click changes to this scene instead of opening the map card.
@export var target_scene: SceneLoader.SCENE = SceneLoader.SCENE.NONE

var _card: MapPointCard

func _ready() -> void:
	var root = get_tree().current_scene
	_card = NodeUtils.get_child_of_type(root, MapPointCard)
	var area = NodeUtils.get_child_of_type(self, Area2D)
	area.input_event.connect(_on_area_2d_input_event)
	area.mouse_entered.connect(_on_area_2d_mouse_entered)
	area.mouse_exited.connect(_on_area_2d_mouse_exited)

func _on_area_2d_mouse_entered() -> void:
	pass

func _on_area_2d_mouse_exited() -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if target_scene != SceneLoader.SCENE.NONE:
			SceneLoader.change_scene(target_scene)
			return
		if _card:
			_card.open(id)
