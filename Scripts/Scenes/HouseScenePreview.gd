class_name HouseScenePreview
extends HouseSceneBase

@onready var dialog_controller: DialogController = $DialogController
@onready var ghost: Node2D = $Ghost

@export var ink_dialog_appear_path : String

func ghost_appear() -> void:
	ghost.visible = true
	dialog_controller.start_story(ink_dialog_appear_path)
