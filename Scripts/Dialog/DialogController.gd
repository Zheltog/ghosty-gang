class_name DialogController

extends Node2D

const timeout_tag: String = "timeout"

@export var story: InkStory
@export var dialogue_actor: DialogueActor
@export var timer: GameTimer

@onready var _box: TextBoxWithOptions = $TextBoxWithOptions

func _ready() -> void:
	VoiceProcessor.register_speaker("bob", 0.75, 1.25)
	InkFunctions.subscribe(self)
	if story:
		start_story()

func load_story(path: String) -> bool:
	var loaded := load(path)
	if loaded == null or not (loaded is InkStory):
		printerr("DialogController: failed to load InkStory at ", path)
		return false
	story = loaded
	story.ResetState()
	InkFunctions.bind_story(story)
	return true

func start_story(path: String = "") -> void:
	if not path.is_empty():
		if not load_story(path):
			return
	if story == null:
		printerr("DialogController: no story loaded")
		return
	story.ResetState()
	InkFunctions.bind_story(story)
	_present_line(true)

func try_next() -> void:
	_present_line(false)

func process_option_selected(id: int) -> void:
	story.ChooseChoiceIndex(id)
	try_next()

func set_box_position(position_id: String) -> void:
	_box.set_box_position(position_id)

func _present_line(force_show: bool) -> void:
	if story == null:
		return
	if not story.GetCanContinue():
		if force_show:
			_process_tags(story.GetCurrentTags())
			_box.show_box_instantly(story.GetCurrentText(), story.GetCurrentChoices(), "bob")
		return
	var text: String = story.Continue()
	_process_tags(story.GetCurrentTags())
	_box.show_box_instantly(text, story.GetCurrentChoices(), "bob")

func _process_tags(tags: Array[String]) -> void:
	var parsed_tags := InkTagParser.parse(tags)
	_process_animation_tag(parsed_tags)
	_process_position_tag(parsed_tags)
	_process_timeout_tag(parsed_tags)

func _process_animation_tag(tags: Dictionary) -> void:
	if dialogue_actor == null:
		return

	var animation_name := StringName(tags.get("anim", ""))
	dialogue_actor.play_dialogue_animation(animation_name)

func _process_position_tag(tags: Dictionary) -> void:
	if not tags.has("pos"):
		return
	set_box_position(str(tags["pos"]))
  
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
