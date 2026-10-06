class_name DialogState

extends RefCounted

const player_phrase_window := "player_phrase"
const thought_window := "thought"
const none_character := "none"
## TODO: temporary override, ignores `skippable:false` / `skip_default:false` tags.
const force_skippable := true

var skippable_default: bool = true
var skippable: bool = true
var instant: bool = false
var response: bool = false
var thought: bool = false
var window_name: String = ""
var has_animation: bool = false
var animation_name: String = ""
var poses: Dictionary = {}
var character_default: String = ""
var character_name: String = ""
var away_character: String = ""
var introduced: bool = false
var speaker_name: String = ""
var timeout_seconds: float = -1.0

func reset() -> void:
	skippable_default = true
	character_default = ""
	poses.clear()
	begin_line()

func begin_line() -> void:
	skippable = skippable_default
	instant = false
	response = false
	thought = false
	window_name = ""
	has_animation = false
	animation_name = ""
	character_name = character_default
	away_character = ""
	introduced = false
	speaker_name = ""
	timeout_seconds = -1.0

func apply(tags: Array[String]) -> void:
	begin_line()
	var parsed := InkTagParser.parse(tags)
	if parsed.has("skip_default"):
		skippable_default = _parse_bool(parsed["skip_default"], skippable_default)
		skippable = skippable_default
	if parsed.has("skippable"):
		skippable = _parse_bool(parsed["skippable"], skippable)
	if force_skippable:
		skippable_default = true
		skippable = true
	instant = parsed.has("instant") and _parse_bool(parsed["instant"], true)
	response = parsed.has("response")
	thought = parsed.has("thought")
	if parsed.has("window"):
		window_name = normalize_window_name(str(parsed["window"]))
		if window_name.is_empty():
			window_name = "default"
	if parsed.has("char_default"):
		character_default = str(parsed["char_default"]).strip_edges()
		character_name = character_default
	if parsed.has("char"):
		character_name = str(parsed["char"]).strip_edges()
	if thought and not parsed.has("char"):
		character_name = none_character
	introduced = parsed.has("introduced")
	if parsed.has("away"):
		var raw := str(parsed["away"]).strip_edges()
		away_character = character_name if raw.is_empty() else raw
	if parsed.has("pose"):
		poses[_pose_key()] = str(parsed["pose"]).strip_edges()
	if parsed.has("anim"):
		has_animation = true
		animation_name = _posed_animation(str(parsed["anim"]).strip_edges())
	if parsed.has("timeout"):
		var raw := str(parsed["timeout"]).strip_edges()
		timeout_seconds = 0.0 if raw.is_empty() else float(raw)

func _parse_bool(value: Variant, fallback: bool) -> bool:
	var normalized := str(value).strip_edges().to_lower()
	if normalized.is_empty():
		return true
	match normalized:
		"true", "1", "yes", "on":
			return true
		"false", "0", "no", "off":
			return false
		_:
			printerr("DialogState: unknown bool tag value '%s'" % value)
			return fallback

func _pose_key() -> String:
	return character_name.strip_edges().to_lower()

func _posed_animation(emotion: String) -> String:
	var pose := str(poses.get(_pose_key(), "")).strip_edges()
	if pose.is_empty() or emotion == pose:
		return emotion if not emotion.is_empty() else pose
	return "%s_%s" % [pose, emotion]

static func normalize_window_name(raw_name: String) -> String:
	return raw_name.strip_edges().to_lower().replace("-", "_").replace(" ", "_")
