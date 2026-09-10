class_name DialogController

extends Node2D

const timeout_tag: String = "timeout"

@export var story: InkStory
@export var dialogue_actor: DialogueActor
@export var timer: GameTimer

@onready var _box: TextBoxWithOptions = $TextBoxWithOptions

func _ready() -> void:
	if story:
		try_next()
	VoiceProcessor.register_speaker("bob", 0.75, 1.25)

func try_next() -> void:
	if not story.GetCanContinue():
		return
	var text: String = story.Continue()
	_process_tags(story.GetCurrentTags())
	_box.show_box_instantly(text, story.GetCurrentChoices(), "bob")

func process_option_selected(id: int) -> void:
	story.ChooseChoiceIndex(id)
	try_next()

func _process_tags(tags: Array[String]) -> void:
	var parsed_tags := InkTagParser.parse(tags)
	_process_animation_tag(parsed_tags)
	_process_timeout_tag(parsed_tags)

func _process_animation_tag(tags: Dictionary) -> void:
	if dialogue_actor == null:
		return

	var animation_name := StringName(tags.get("anim", ""))
	dialogue_actor.play_dialogue_animation(animation_name)

func _process_timeout_tag(tags: Dictionary) -> void:
	if timer == null:
		return
	var timeout_value_str = tags.get(timeout_tag, null)
	if timeout_value_str == null:
		return
	var timeout_value = float(timeout_value_str)
	if timeout_value == 0:
		timer.reset()
		return
	var choices = story.GetCurrentChoices()
	if choices.size() == 0:
		timer.start(timeout_value, func(): print("TIMER TIMED OUT"))
	else:
		timer.start(timeout_value, func(): process_option_selected(0))
