class_name DialogController

extends Node2D

signal story_finished(story_name: String)

@export var story: InkStory
@export var timer: GameTimer
@export var response_continue_delay: float = 0.75

@onready var _windows: DialogWindowManager = $DialogWindowManager

var _state := DialogState.new()
var _reactions := DialogReactions.new()
var _current_choices: Array = []
var _story_path: String = ""
var _story_finished := false
static var dialog_active := false
static var world_locked := true

func _ready() -> void:
	_windows.setup(self, _state)
	_reactions.setup(_state, _windows)
	InkFunctions.subscribe(self)
	if story:
		_story_path = story.resource_path
		start_story()

func load_story(path: String) -> bool:
	var loaded := load(path)
	if loaded == null or not (loaded is InkStory):
		printerr("DialogController: failed to load InkStory at ", path)
		return false
	story = loaded
	_story_path = path
	story.ResetState()
	InkFunctions.bind_story(story)
	_state.reset()
	return true

func start_story(path: String = "", lock_world: bool = true) -> void:
	if not path.is_empty() and not load_story(path):
		return
	if story == null:
		printerr("DialogController: no story loaded")
		return
	visible = true
	_story_finished = false
	dialog_active = true
	world_locked = lock_world
	if _story_path.is_empty():
		_story_path = story.resource_path
	story.ResetState()
	InkFunctions.bind_story(story)
	InkVariableStore.apply(story, _story_path)
	_state.reset()
	_reactions.reset(story)
	_windows.reset()
	_present_line()

func proceed() -> void:
	_present_line()

func process_option_selected(id: int, box: BoxOptionButton = null) -> void:
	if story == null:
		return
	_clear_choice_timer()
	if box == null:
		box = _windows.find_option_button(id)
	await _windows.confirm_option(box)
	if story == null:
		return
	story.ChooseChoiceIndex(id)
	_present_line()

static func is_dialog_active() -> bool:
	return dialog_active

static func is_world_locked() -> bool:
	return world_locked

func try_inventory_choice(event: Inventory.EVENT, item_id: InventoryItemGenerator.INVENTORY_ITEM) -> bool:
	var item_name = InventoryItemGenerator.INVENTORY_ITEM.find_key(item_id)
	if story == null or item_name == null:
		return false
	var item_token := str(item_name).to_lower()
	return _divert_reaction(func(token: Dictionary) -> bool:
		if token.get("kind") != "inventory" or token.get("event") != event:
			return false
		var item := str(token.get("item", ""))
		return item.is_empty() or item == item_token
	)

func try_action(action_name: String) -> bool:
	var action_token := action_name.strip_edges().to_lower()
	if story == null or action_token.is_empty():
		return false
	return _divert_reaction(func(token: Dictionary) -> bool:
		return token.get("kind") == "action" and token.get("action") == action_token
	)

func start_option_timeout() -> void:
	if timer == null or timer.holds_reset() or _state.timeout_seconds < 0.0:
		return
	if _state.timeout_seconds == 0.0:
		_clear_choice_timer()
		return
	var visible_choices := _visible_choices(_current_choices)
	if visible_choices.is_empty():
		return
	timer.start(_state.timeout_seconds, func(): process_option_selected(visible_choices[0].GetIndex()))

func _clear_choice_timer() -> void:
	if timer == null or timer.holds_reset():
		return
	timer.reset()

func _present_line() -> void:
	if story == null:
		return
	_clear_choice_timer()
	var advanced := _advance_to_line()
	_current_choices = _read_choices()
	var visible_choices := _visible_choices(_current_choices)
	if advanced:
		_show_current_line(str(story.GetCurrentText()), visible_choices)
		return
	if not _current_choices.is_empty():
		return
	if _reactions.try_return():
		_current_choices = _read_choices()
		_show_current_line(str(story.GetCurrentText()), _visible_choices(_current_choices))
		return
	_finish_story()

# Skips empty tag lines. Returns true when a spoken line or a visible choice is reached.
func _advance_to_line() -> bool:
	while story.GetCanContinue():
		var text: Variant = story.Continue()
		_current_choices = _read_choices()
		var line := "" if text == null else str(text).strip_edges()
		if line.is_empty() and _visible_choices(_current_choices).is_empty():
			_apply_line()
			continue
		return true
	return false

func _finish_story() -> void:
	InkVariableStore.capture(story, _story_path)
	_windows.close()
	dialog_active = false
	world_locked = true
	if _story_finished:
		return
	_story_finished = true
	story_finished.emit(_story_name())

func _story_name() -> String:
	var names := InkTagParser.values_for_key(_story_source_tags(), "story")
	if names.is_empty():
		return ""
	return names[0]

func _story_source_tags() -> Array[String]:
	return InkTagParser.read_global_tags_from_text(_story_source_text())

func _story_source_text() -> String:
	if story != null and story.has_method("GetSourceText"):
		var stored := str(story.GetSourceText())
		if not stored.is_empty():
			return stored
	return InkTagParser.read_text_file(_story_path)

func _show_current_line(text: String, choices: Array) -> void:
	_apply_line()
	if _state.introduced and not _state.character_name.is_empty():
		StateManager.set_state(_state.character_name + "_introduced", true)
	_state.speaker_name = _speaker_name()
	_windows.display(text, choices)

func _apply_line() -> void:
	var tags = story.GetCurrentTags()
	if tags == null:
		tags = []
	_state.apply(tags)
	_reactions.update(tags)
	_play_animation()

func _speaker_name() -> String:
	var speaker := DialogState.none_character if _state.thought else _state.character_name
	speaker = speaker.strip_edges().to_lower()
	if speaker.is_empty() or not VoiceProcessor.has_speaker(speaker):
		return ""
	return speaker

func _play_animation() -> void:
	if not _state.has_animation:
		return
	if _state.character_name.is_empty():
		printerr("DialogController: # anim without current character")
		return
	var character := _find_character(_state.character_name)
	if character == null:
		printerr("DialogController: no character named '%s'" % _state.character_name)
		return
	character.set_emotion(_state.animation_name)

func _find_character(character_name: String) -> SceneCharacter:
	var needle := character_name.strip_edges().to_lower()
	if needle.is_empty():
		return null
	var scene := get_tree().current_scene
	if scene != null:
		for node in scene.find_children("*", "SceneCharacter", true, false):
			var character := node as SceneCharacter
			if character.character_name.strip_edges().to_lower() == needle:
				return character
	var house := HouseSceneBase.current_house_scene
	if house == null:
		return null
	return house.find_character(character_name)

func _read_choices() -> Array:
	var choices = story.GetCurrentChoices()
	return [] if choices == null else choices

func _visible_choices(choices: Array) -> Array:
	var visible: Array = []
	for choice in choices:
		if choice == null:
			continue
		visible.append(choice)
	return visible

func _divert_reaction(matches: Callable) -> bool:
	var reaction := _reactions.find(matches)
	if reaction.is_empty():
		return false
	_clear_choice_timer()
	_reactions.divert(reaction)
	_present_line()
	return true
