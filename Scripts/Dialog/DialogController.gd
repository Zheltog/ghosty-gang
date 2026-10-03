class_name DialogController

extends Node2D

signal story_finished(story_name: String)

@export var story: InkStory
@export var timer: GameTimer
@export var response_continue_delay: float = 0.75

@onready var _windows: DialogWindowManager = $DialogWindowManager

var _state := DialogState.new()
var _current_choices: Array = []
var _story_path: String = ""
var _story_finished := false
var _present_characters: Array[String] = []

func _ready() -> void:
	_windows.setup(self, _state)
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

func start_story(path: String = "") -> void:
	if not path.is_empty():
		if not load_story(path):
			return
	if story == null:
		printerr("DialogController: no story loaded")
		return
	visible = true
	_story_finished = false
	_present_characters.clear()
	_apply_presence()
	if _story_path.is_empty():
		_story_path = story.resource_path
	story.ResetState()
	InkFunctions.bind_story(story)
	InkVariableStore.apply(story, _story_path)
	_state.reset()
	_windows.reset()
	_present_line()

func proceed() -> void:
	_present_line()

func process_option_selected(id: int, box: BoxOptionButton = null) -> void:
	if story == null:
		return
	if timer:
		timer.reset()
	if box == null:
		box = _windows.find_option_button(id)
	await _windows.confirm_option(box)
	if story == null:
		return
	story.ChooseChoiceIndex(id)
	_present_line()

func try_inventory_choice(event: Inventory.EVENT, item_id: InventoryItemGenerator.INVENTORY_ITEM) -> bool:
	if story == null:
		return false
	var item_name = InventoryItemGenerator.INVENTORY_ITEM.find_key(item_id)
	if item_name == null:
		return false
	var item_token := str(item_name).to_lower()
	for choice in _current_choices:
		if _choice_matches_inventory(choice, event, item_token):
			process_option_selected(choice.GetIndex())
			return true
	return false

func try_action(action_name: String) -> bool:
	if story == null:
		return false
	var action_token := action_name.strip_edges().to_lower()
	if action_token.is_empty():
		return false
	for choice in _current_choices:
		if _choice_matches_action(choice, action_token):
			process_option_selected(choice.GetIndex())
			return true
	return false

func start_option_timeout() -> void:
	if timer == null or _state.timeout_seconds < 0.0:
		return
	if _state.timeout_seconds == 0.0:
		timer.reset()
		return
	var visible := _visible_choices(_current_choices)
	if visible.is_empty():
		return
	timer.start(_state.timeout_seconds, func(): process_option_selected(visible[0].GetIndex()))

func _present_line() -> void:
	if story == null:
		return
	_state.begin_line()
	if timer:
		timer.reset()
	# Skips empty lines. Specifically needed for dialog to properly end
	while story.GetCanContinue():
		var text: Variant = story.Continue()
		_current_choices = _read_choices()
		var visible_choices := _visible_choices(_current_choices)
		var line := "" if text == null else str(text).strip_edges()
		if line.is_empty() and visible_choices.is_empty():
			if not story.GetCurrentTags().is_empty():
				_state.apply(story.GetCurrentTags())
				_sync_present_characters()
				_apply_character_animation()
			continue
		_show_current_line(line if not line.is_empty() else str(story.GetCurrentText()), visible_choices)
		if not story.GetCanContinue() and _current_choices.is_empty():
			InkVariableStore.capture(story, _story_path)
		return
	_current_choices = _read_choices()
	var visible_choices_at_end := _visible_choices(_current_choices)
	if not visible_choices_at_end.is_empty():
		_show_current_line(str(story.GetCurrentText()), visible_choices_at_end)
		return
	_finish_story()

func _finish_story() -> void:
	InkVariableStore.capture(story, _story_path)
	_windows.close()
	if _story_finished:
		return
	_story_finished = true
	story_finished.emit(_story_name())

func _story_name() -> String:
	var names := InkTagParser.values_for_key(
		InkTagParser.read_global_tags_from_file(_story_path),
		"story"
	)
	if names.is_empty():
		return ""
	return names[0]

func _show_current_line(text: String, choices: Array) -> void:
	_state.apply(story.GetCurrentTags())
	if _state.introduced and not _state.character_name.is_empty():
		StateManager.set_state(_state.character_name + "_introduced", true)
	_sync_present_characters()
	_state.speaker_name = _speaker_for_current_line()
	_apply_character_animation()
	_windows.display(text, choices)

func _sync_present_characters() -> void:
	if _stage_character(_state.character_name) != null:
		_set_present(_state.character_name, true)
	if not _state.away_character.is_empty():
		_set_present(_state.away_character, false)
	_apply_presence()

func _set_present(character_name: String, present: bool) -> void:
	var key := character_name.strip_edges().to_lower()
	if key.is_empty():
		return
	if present:
		if not _present_characters.has(key):
			_present_characters.append(key)
	else:
		_present_characters.erase(key)

func _apply_presence() -> void:
	var scene := get_tree().current_scene
	if scene == null or scene is HouseSceneBase:
		return
	for node in scene.find_children("*", "SceneCharacter", true, false):
		var character := node as SceneCharacter
		if character.sprite == null:
			continue
		var key := character.character_name.strip_edges().to_lower()
		character.visible = _present_characters.has(key)

func _stage_character(character_name: String) -> SceneCharacter:
	var character := _find_character(character_name)
	if character == null or character.sprite == null:
		return null
	return character

func _speaker_for_current_line() -> String:
	var speaker := DialogState.none_character if _state.thought else _state.character_name
	if speaker.is_empty():
		return ""
	var character := _find_character(speaker)
	if character == null or not character.has_voice:
		return ""
	return character.character_name

func _apply_character_animation() -> void:
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
		if choice == null or _is_hidden_inventory_choice(choice):
			continue
		visible.append(choice)
	return visible

func _is_hidden_inventory_choice(choice) -> bool:
	return not _parse_choice_token(choice.GetText()).is_empty()

func _choice_matches_inventory(choice, event: Inventory.EVENT, item_name: String) -> bool:
	if _inventory_token_matches(_parse_choice_token(choice.GetText()), event, item_name):
		return true
	var tags = choice.GetTags()
	if tags == null:
		return false
	for tag in tags:
		if _inventory_token_matches(_parse_choice_token(str(tag)), event, item_name):
			return true
	return false

func _choice_matches_action(choice, action_name: String) -> bool:
	if _action_token_matches(_parse_choice_token(choice.GetText()), action_name):
		return true
	var tags = choice.GetTags()
	if tags == null:
		return false
	for tag in tags:
		if _action_token_matches(_parse_choice_token(str(tag)), action_name):
			return true
	return false

func _inventory_token_matches(parsed: Dictionary, event: Inventory.EVENT, item_name: String) -> bool:
	if parsed.is_empty() or parsed.get("kind") != "inventory":
		return false
	if parsed.event != event:
		return false
	if str(parsed.item).is_empty():
		return true
	return parsed.item == item_name

func _action_token_matches(parsed: Dictionary, action_name: String) -> bool:
	return parsed.get("kind") == "action" and parsed.get("action") == action_name

func _parse_choice_token(text: String) -> Dictionary:
	var normalized := text.strip_edges().to_lower()
	if normalized == "unequip" or normalized == "uneqip":
		return {"kind": "inventory", "event": Inventory.EVENT.UNEQUIP, "item": ""}
	var separator := normalized.find(":")
	if separator <= 0:
		return {}
	var prefix := normalized.substr(0, separator)
	var value := normalized.substr(separator + 1)
	if value.is_empty() or value.contains(" "):
		return {}
	if prefix == "action":
		return {"kind": "action", "action": value}
	var event_key := prefix.to_upper()
	if not Inventory.EVENT.keys().has(event_key):
		return {}
	return {"kind": "inventory", "event": Inventory.EVENT[event_key], "item": value}
