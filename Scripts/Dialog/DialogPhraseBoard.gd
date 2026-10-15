class_name DialogPhraseBoard

extends VBoxContainer

const MARK := "%%"

@export var phrase_scene: PackedScene
@export var show_history: bool = true:
	set(value):
		show_history = value
		if is_node_ready():
			_sync_history()

var printing_speed: float = INF
var delay_multiplier: float = 4.0
var stack_lines: bool = true

var _manager: DialogWindowManager
@onready var _history: ColorRect = $History
@onready var _stack: VBoxContainer = $History/Stack

var _phrases: Array[DialogPhrase] = []
var _options: Array = []
var _options_at: int = -1
var _opened_options: bool
var _text: String = ""
var _shown: int
var _printing: bool
var _id: int
var _speaker: String = ""
var _delay: float
var _phrase: DialogPhrase

func _ready() -> void:
	_history.resized.connect(_pin_stack)
	_sync_history()

func setup(manager: DialogWindowManager) -> void:
	_manager = manager
	_strip_preview()
	_sync_history()

func _strip_preview() -> void:
	for node in _stack.get_children():
		node.free()
	for node in get_children():
		if node is DialogPhrase:
			node.free()

func show_line(text: String, options: Array, state: DialogState) -> void:
	interrupt()
	_speaker = "" if state == null else state.speaker_name
	var instant := state != null and state.instant
	_delay = 0.0 if instant or printing_speed <= 0.0 or not is_finite(printing_speed) else 1.0 / printing_speed
	_options = options
	_options_at = text.find(MARK)
	_opened_options = false
	_text = text.replace(MARK, "")
	_shown = 0
	_begin(_text, _type_of(state), _who(state))
	_print()

func skip() -> void:
	if not _printing:
		return
	interrupt()
	_reveal(_text.length())
	_finish()

func interrupt() -> void:
	_printing = false
	_id += 1

func is_printing() -> bool:
	return _printing

func has_options() -> bool:
	return not _options.is_empty()

func clear() -> void:
	_options = []
	_phrase = null
	for phrase in _phrases:
		if is_instance_valid(phrase):
			phrase.free()
	_phrases.clear()
	_sync_history()

func _begin(text: String, type: DialogPhrase.Type, who: String) -> void:
	if _phrase:
		if show_history:
			_phrase.reparent(_stack)
			_phrase.store()
		else:
			_phrases.erase(_phrase)
			_phrase.free()
		_phrase = null
	_sync_history()
	if text.is_empty():
		return
	_phrase = phrase_scene.instantiate()
	_phrase.type = type
	add_child(_phrase)
	_phrase.size.x = size.x
	_phrase.custom_minimum_size.x = size.x
	_phrase.present(text, who)
	_phrases.append(_phrase)

func _sync_history() -> void:
	var filled := show_history and _stack.get_child_count() > 0
	_history.visible = show_history
	_history.size_flags_vertical = SIZE_EXPAND_FILL if filled else 0
	_pin_stack()
	call_deferred("_pin_stack")

func _pin_stack() -> void:
	if _history == null or _stack == null:
		return
	var height := _stack.get_combined_minimum_size().y
	_stack.set_anchor(SIDE_LEFT, 0.0)
	_stack.set_anchor(SIDE_TOP, 1.0)
	_stack.set_anchor(SIDE_RIGHT, 1.0)
	_stack.set_anchor(SIDE_BOTTOM, 1.0)
	_stack.offset_left = 0.0
	_stack.offset_right = 0.0
	_stack.offset_bottom = 0.0
	_stack.offset_top = -height
	_stack.grow_vertical = GROW_DIRECTION_BEGIN

func _print() -> void:
	_id += 1
	var token := _id
	if _text.is_empty() or _delay <= 0.0:
		_reveal(_text.length())
		_printing = false
		if not _text.is_empty():
			_blip()
		_finish()
		return
	_printing = true
	_reveal(0)
	_options_if_ready()
	var prev := ""
	for character in _text:
		await get_tree().create_timer(_wait(prev, character)).timeout
		if not _printing or _id != token:
			return
		if not " \n\t".contains(character) and not ".,?!:;-()\"\"".contains(character):
			_blip()
		_reveal(_shown + 1)
		prev = character
		_options_if_ready()
	_printing = false
	_finish()

func _reveal(count: int) -> void:
	_shown = count
	if _phrase:
		_phrase.reveal(count)

func _finish() -> void:
	_options_if_ready()
	if _manager:
		_manager.on_line_finished()

func _options_if_ready() -> void:
	if _opened_options:
		return
	if _options_at >= 0 and _shown < _options_at:
		return
	if _options_at < 0 and _printing:
		return
	_opened_options = true
	if _manager:
		_manager.reveal_options(_options)

func _type_of(state: DialogState) -> DialogPhrase.Type:
	if state == null:
		return DialogPhrase.Type.REPLICA
	if state.thought:
		return DialogPhrase.Type.THOUGHT
	if state.response:
		return DialogPhrase.Type.RESPONSE
	return DialogPhrase.Type.REPLICA

func _who(state: DialogState) -> String:
	if state == null or _type_of(state) != DialogPhrase.Type.REPLICA:
		return ""
	return CharacterNames.display_name(state.character_name)

func _wait(prev: String, next: String) -> float:
	if (".,?!:;-()\"\"".contains(prev) and " \n\t".contains(next)) or next == "\n":
		return _delay * delay_multiplier
	return _delay

func _blip() -> void:
	if not _speaker.is_empty():
		AudioEventBus.play_speaker_voice_sound.emit(_speaker)
