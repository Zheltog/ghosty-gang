class_name DialogReactions

extends RefCounted

const FLOW := "reaction_%d"

var _story: InkStory
var _state: DialogState
var _windows: DialogWindowManager
var _defaults: Array = []
var _line_reactions: Array = []
var _returns: Array[Dictionary] = []

func setup(state: DialogState, windows: DialogWindowManager) -> void:
	_state = state
	_windows = windows

func reset(story: InkStory) -> void:
	_story = story
	_defaults.clear()
	_line_reactions.clear()
	_returns.clear()

func in_reaction() -> bool:
	return not _returns.is_empty()

func update(tags: Array) -> void:
	if _has_tag_key(tags, "react_default"):
		_defaults = _parse_reactions(InkTagParser.values_for_key(tags, "react_default"))
	if _has_tag_key(tags, "react"):
		_line_reactions = _parse_reactions(InkTagParser.values_for_key(tags, "react"))
	else:
		_line_reactions = _defaults.duplicate(true)

func find(matches: Callable) -> Dictionary:
	for reaction in _line_reactions:
		if matches.call(reaction):
			return reaction
	return {}

func divert(reaction: Dictionary) -> void:
	if reaction.get("back", false):
		_enter_flow()
		_story.ChoosePathString(reaction["path"])
	else:
		_story.ChoosePathString(reaction["path"], false)

# Called when the current flow runs out. Returns true when the interrupted flow and its saved state are restored,
# so the caller has to show its current line again: Continue() already read it.
func try_return() -> bool:
	if not in_reaction():
		return false
	if _flow_hit_end():
		while in_reaction():
			_leave_flow()
		return false
	var saved := _leave_flow()
	_state.copy_from(saved["state"])
	_defaults = saved["defaults"]
	_windows.load_window(saved["window"])
	return true

# Each `:back` reaction runs in its own Ink flow, so the flow it interrupted keeps its line and choices.
func _enter_flow() -> void:
	_returns.append({
		"state": _state.snapshot(),
		"defaults": _defaults.duplicate(true),
		"window": _windows.save_window(),
	})
	_story.SwitchFlow(FLOW % _returns.size())

func _leave_flow() -> Dictionary:
	var flow_name := FLOW % _returns.size()
	var saved: Dictionary = _returns.pop_back()
	if _returns.is_empty():
		_story.SwitchToDefaultFlow()
	else:
		_story.SwitchFlow(FLOW % _returns.size())
	_story.RemoveFlow(flow_name)
	return saved

# `-> END` resets the flow's thread and drops its previous content; `-> DONE` keeps it.
func _flow_hit_end() -> bool:
	var saved: Variant = JSON.parse_string(_story.SaveState())
	if not (saved is Dictionary):
		return false
	var flow: Variant = saved.get("flows", {}).get(FLOW % _returns.size())
	if not (flow is Dictionary):
		return false
	var threads: Array = flow.get("callstack", {}).get("threads", [])
	if threads.is_empty():
		return false
	return not (threads[-1] as Dictionary).has("previousContentObject")

func _has_tag_key(tags: Array, key: String) -> bool:
	var needle := key.strip_edges().to_lower()
	var prefix := needle + ":"
	for tag in tags:
		var normalized := str(tag).strip_edges().to_lower()
		if normalized == needle or normalized.begins_with(prefix):
			return true
	return false

func _parse_reactions(values: Array) -> Array:
	var reactions: Array = []
	for value in values:
		var reaction := _parse_reaction(str(value))
		if reaction.is_empty():
			printerr("DialogReactions: bad reaction '%s'" % value)
			continue
		reactions.append(reaction)
	return reactions

func _parse_reaction(value: String) -> Dictionary:
	var parts := value.strip_edges().to_lower().split(":")
	if parts.size() < 3 or parts.size() > 4 or parts[1].is_empty() or parts[1].contains(" "):
		return {}
	var path := parts[2].strip_edges()
	if path.is_empty() or path.contains(" "):
		return {}
	if parts.size() == 4 and parts[3].strip_edges() != "back":
		return {}
	var back := parts.size() == 4
	if parts[0] == "action":
		return {"kind": "action", "action": parts[1], "path": path, "back": back}
	var event_key := parts[0].to_upper()
	if event_key == "UNEQIP":
		event_key = "UNEQUIP"
	if not Inventory.EVENT.keys().has(event_key):
		return {}
	return {"kind": "inventory", "event": Inventory.EVENT[event_key], "item": parts[1], "path": path, "back": back}
