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
static var dialog_active := false
static var world_locked := true

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
	_hide_stage()
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
	return _choose(func(token: Dictionary) -> bool:
		if token.get("kind") != "inventory" or token.get("event") != event:
			return false
		var item := str(token.get("item", ""))
		return item.is_empty() or item == item_token
	)

func try_action(action_name: String) -> bool:
	var action_token := action_name.strip_edges().to_lower()
	if story == null or action_token.is_empty():
		return false
	return _choose(func(token: Dictionary) -> bool:
		return token.get("kind") == "action" and token.get("action") == action_token
	)

func start_option_timeout() -> void:
	if timer == null or timer.holds_reset() or _state.timeout_seconds < 0.0:
		return
	if _state.timeout_seconds == 0.0:
		_clear_choice_timer()
		return
	var visible := _visible_choices(_current_choices)
	if visible.is_empty():
		return
	timer.start(_state.timeout_seconds, func(): process_option_selected(visible[0].GetIndex()))

func _clear_choice_timer() -> void:
	if timer == null or timer.holds_reset():
		return
	timer.reset()

func _present_line() -> void:
	if story == null:
		return
	_state.begin_line()
	_clear_choice_timer()
	# Skips empty lines. Specifically needed for dialog to properly end
	while story.GetCanContinue():
		var text: Variant = story.Continue()
		_current_choices = _read_choices()
		var visible := _visible_choices(_current_choices)
		var line := "" if text == null else str(text).strip_edges()
		if line.is_empty() and visible.is_empty():
			_apply_tag_only_line()
			continue
		_show_current_line(line if not line.is_empty() else str(story.GetCurrentText()), visible)
		if not story.GetCanContinue() and _current_choices.is_empty():
			InkVariableStore.capture(story, _story_path)
		return
	_current_choices = _read_choices()
	var pending := _visible_choices(_current_choices)
	if pending.is_empty():
		_finish_story()
		return
	_show_current_line(str(story.GetCurrentText()), pending)

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
	var names := InkTagParser.values_for_key(
		InkTagParser.read_global_tags_from_file(_story_path),
		"story"
	)
	if names.is_empty():
		return ""
	return names[0]

func _show_current_line(text: String, choices: Array) -> void:
	_apply_line()
	if _state.introduced and not _state.character_name.is_empty():
		StateManager.set_state(_state.character_name + "_introduced", true)
	_state.speaker_name = _speaker_name()
	_windows.display(text, choices)

func _apply_tag_only_line() -> void:
	if story.GetCurrentTags().is_empty():
		return
	_apply_line()

func _apply_line() -> void:
	_state.apply(story.GetCurrentTags())
	_update_stage()
	_play_animation()

func _hide_stage() -> void:
	for character in _staged_characters():
		character.visible = false

func _update_stage() -> void:
	_set_staged(_state.character_name, true)
	_set_staged(_state.away_character, false)

func _set_staged(character_name: String, shown: bool) -> void:
	var key := character_name.strip_edges().to_lower()
	if key.is_empty():
		return
	for character in _staged_characters():
		if character.character_name.strip_edges().to_lower() == key:
			character.visible = shown

func _staged_characters() -> Array[SceneCharacter]:
	var staged: Array[SceneCharacter] = []
	var scene := get_tree().current_scene
	if scene == null or scene is HouseSceneBase:
		return staged
	for node in scene.find_children("*", "SceneCharacter", true, false):
		var character := node as SceneCharacter
		if character.sprite != null:
			staged.append(character)
	return staged

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
		if choice == null or _is_hidden_choice(choice):
			continue
		visible.append(choice)
	return visible

func _is_hidden_choice(choice) -> bool:
	return not _parse_choice_token(choice.GetText()).is_empty()

func _choose(matches: Callable) -> bool:
	for choice in _current_choices:
		if _choice_matches(choice, matches):
			process_option_selected(choice.GetIndex())
			return true
	return false

func _choice_matches(choice, matches: Callable) -> bool:
	if matches.call(_parse_choice_token(choice.GetText())):
		return true
	var tags = choice.GetTags()
	if tags == null:
		return false
	for tag in tags:
		if matches.call(_parse_choice_token(str(tag))):
			return true
	return false

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
