class_name SceneItemUI
extends Node

@export var scene_item_id : SceneItemGenerator.SCENE_ITEM

@onready var _area_2d: Area2D = $Area2D

var _scene_item : SceneItemBase
var _scene_object_manager : SceneObjectsManager
func set_scene_object_manager(scene_object_manager : SceneObjectsManager) -> void:
	_scene_object_manager = scene_object_manager

func _ready() -> void:
	_scene_item = SceneItemGenerator.generate(scene_item_id)
	_area_2d.mouse_entered.connect(_on_mouse_entered)
	_area_2d.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	# getting every time since interacation type might change
	var intercation_type = _scene_item.get_interaction_type()
	_scene_object_manager.highlight_item(self, intercation_type)

func _on_mouse_exited() -> void:
	_scene_object_manager.unhighlight_item(self)
