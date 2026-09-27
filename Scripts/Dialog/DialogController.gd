class_name DialogController

extends Node2D

const timeout_tag: String = "timeout"

@export var story: InkStory
@export var timer: GameTimer

@onready var _box: TextBoxWithOptions = $TextBoxWithOptions

var _skippable_default: bool = true
var _current_line_skippable: bool = true
var _current_choices: Array = []
var _story_path: String = ""

func _ready() -> void:
	VoiceProcessor.register_speaker("bob", 0.75, 1.25)
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
	_reset_skip_state()
	return true

func start_story(path: String = "") -> void:
	if not path.is_empty():
		if not load_story(path):
			return
	if story == null:
		printerr("DialogController: no story loaded")
		return
	visible = true
	if _story_path.is_empty():
		_story_path = story.resource_path
	story.ResetState()
	InkFunctions.bind_story(story)
	InkVariableStore.apply(story, _story_path)
	_reset_skip_state()
	_present_line()

func try_next() -> void:
	if _box.is_printing():
		if _current_line_skippable:
			_box.skip_printing()
		return
	_present_line()

func process_option_selected(id: int) -> void:
	if story == null:
		return
	_box.interrupt_printing()
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

func set_box_position(position_id: String) -> void:
	_box.set_box_position(position_id)

func start_option_timeout() -> void:
	if timer == null:
		return
	_process_timeout_tag(InkTagParser.parse(story.GetCurrentTags()))

func _present_line() -> void:
	if story == null:
		return
	if timer:
		timer.reset()
	# Skips empty lines. Specifically needed for dialog to properly end
	while story.GetCanContinue():
		var text: Variant = story.Continue()
		_current_choices = story.GetCurrentChoices()
		var visible_choices := _visible_choices(_current_choices)
		var line := "" if text == null else str(text).strip_edges()
		if line.is_empty() and visible_choices.is_empty():
			continue
		_process_tags(story.GetCurrentTags())
		var display := line if not line.is_empty() else str(story.GetCurrentText())
		_box.show_box_instantly(display, visible_choices, "bob")
		if not story.GetCanContinue() and _current_choices.is_empty():
			InkVariableStore.capture(story, _story_path)
		return
	_current_choices = story.GetCurrentChoices()
	var visible_choices_at_end := _visible_choices(_current_choices)
	if not visible_choices_at_end.is_empty():
		_process_tags(story.GetCurrentTags())
		_box.show_box_instantly(str(story.GetCurrentText()), visible_choices_at_end, "bob")
		return
	InkVariableStore.capture(story, _story_path)
	_box.hide_box_instantly()

func _process_tags(tags: Array[String]) -> void:
	var parsed_tags := InkTagParser.parse(tags)
	_process_animation_tag(parsed_tags)
	_process_position_tag(parsed_tags)
	_process_skip_tags(parsed_tags)

func _reset_skip_state() -> void:
	_skippable_default = true
	_current_line_skippable = true
	_current_choices = []

func _process_skip_tags(tags: Dictionary) -> void:
	_current_line_skippable = _skippable_default
	if tags.has("skip_default"):
		_skippable_default = _parse_bool_tag(tags["skip_default"], _skippable_default)
		_current_line_skippable = _skippable_default
	if tags.has("skippable"):
		_current_line_skippable = _parse_bool_tag(tags["skippable"], _current_line_skippable)

func _parse_bool_tag(value: Variant, fallback: bool) -> bool:
	var normalized := str(value).strip_edges().to_lower()
	if normalized.is_empty():
		return true
	match normalized:
		"true", "1", "yes", "on":
			return true
		"false", "0", "no", "off":
			return false
		_:
			printerr("DialogController: unknown bool tag value '%s'" % value)
			return fallback

func _process_animation_tag(tags: Dictionary) -> void:
	var animation_name := StringName(tags.get("anim", ""))
	if tags.has("anim") and HouseSceneBase.current_house_scene:
		HouseSceneBase.current_house_scene.set_characters_emotion(str(animation_name))

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
	var visible := _visible_choices(_current_choices)
	if visible.is_empty():
		return
	timer.start(timeout_value, func(): process_option_selected(visible[0].GetIndex()))

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
