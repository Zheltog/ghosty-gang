class_name DialogState

extends RefCounted

const player_phrase_window := "player_phrase"
const thought_window := "thought"
const none_character := "none"

var skippable_default: bool = true
var skippable: bool = true
var instant: bool = false
var response: bool = false
var thought: bool = false
var window_name: String = ""
var has_animation: bool = false
var animation_name: String = ""
var character_default: String = ""
var character_name: String = ""
var away_character: String = ""
var speaker_name: String = ""
var timeout_seconds: float = -1.0

func reset() -> void:
	skippable_default = true
	character_default = ""
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
	if parsed.has("away"):
		var raw := str(parsed["away"]).strip_edges()
		away_character = character_name if raw.is_empty() else raw
	if parsed.has("anim"):
		has_animation = true
		animation_name = str(parsed["anim"])
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

static func normalize_window_name(raw_name: String) -> String:
	return raw_name.strip_edges().to_lower().replace("-", "_").replace(" ", "_")
