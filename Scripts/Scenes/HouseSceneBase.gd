class_name HouseSceneBase
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InkFunctions.subscribe(self)
