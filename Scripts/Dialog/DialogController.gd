class_name DialogController

extends Node2D

@export var story: InkStory
@export var dialogue_actor: DialogueActor

@onready var _box: TextBoxWithOptions = $TextBoxWithOptions

func _ready() -> void:
	VoiceProcessor.register_speaker("bob", 0.75, 1.25)
	if story:
		try_next()

func start_story(path: String) -> void:
	var loaded := load(path)
	if loaded == null or not (loaded is InkStory):
		printerr("DialogController: failed to load InkStory at ", path)
		return
	story = loaded
	story.ResetState()
	try_next()

func try_next() -> void:
	if story == null or not story.GetCanContinue():
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

func _process_animation_tag(tags: Dictionary) -> void:
	if dialogue_actor == null:
		return

	var animation_name := StringName(tags.get("anim", ""))
	dialogue_actor.play_dialogue_animation(animation_name)
