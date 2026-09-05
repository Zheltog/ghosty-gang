class_name DialogController

extends Node2D

@export var story: InkStory

@onready var _box: TextBoxWithOptions = $TextBoxWithOptions

func _ready() -> void:
	try_next()

func try_next() -> void:
	if not story.GetCanContinue():
		return
	_box.show_box_instantly(story.Continue(), story.GetCurrentChoices())

func process_option_selected(id: int) -> void:
	story.ChooseChoiceIndex(id)
	try_next()
