class_name DialogController

extends Node2D

@export var story: InkStory
@export var dialogue_actor: DialogueActor

@onready var _box: TextBoxWithOptions = $TextBoxWithOptions

func _ready() -> void:
	try_next()

func try_next() -> void:
	if not story.GetCanContinue():
		return
	var text: String = story.Continue()
	_process_tags(story.GetCurrentTags())
	_box.show_box_instantly(text, story.GetCurrentChoices())

func process_option_selected(id: int) -> void:
	story.ChooseChoiceIndex(id)
	try_next()

func _process_tags(tags: Array[String]) -> void:
	var parsed_tags := InkTagParser.parse(tags)
	_process_animation_tag(parsed_tags)

func _process_animation_tag(tags: Dictionary) -> void:
	if dialogue_actor == null:
		return

	var animation_name := StringName(tags.get("anim", ""))
	dialogue_actor.play_dialogue_animation(animation_name)
