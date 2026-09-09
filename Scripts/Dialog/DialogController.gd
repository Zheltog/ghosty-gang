class_name DialogController

extends Node2D

@export var story: InkStory

@onready var _box: TextBoxWithOptions = $TextBoxWithOptions

func _ready() -> void:
	if story:
		try_next()
	VoiceProcessor.register_speaker("bob", 0.75, 1.25)

func try_next() -> void:
	if not story.GetCanContinue():
		return
	_box.show_box_instantly(story.Continue(), story.GetCurrentChoices(), "bob")

func process_option_selected(id: int) -> void:
	story.ChooseChoiceIndex(id)
	try_next()
