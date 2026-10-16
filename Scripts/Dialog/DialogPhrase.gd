class_name DialogPhrase

extends VBoxContainer

enum Type { REPLICA, RESPONSE, THOUGHT }

@export var type: Type = Type.REPLICA
@export var thought_color: Color = Color(0.70, 0.78, 0.88)
@export var ink_color: Color = Color(0.82, 0.82, 0.82)
@export var stored_modulate: Color = Color(0.7, 0.7, 0.7)
@export var stored_name_size: int = 28
@export var stored_body_size: int = 32

@onready var speaker_name: Label = $Name
@onready var body: RichTextLabel = $Body

var _source: String = ""

func present(text: String, who: String = "") -> void:
	speaker_name.text = who
	speaker_name.visible = type == Type.REPLICA and not who.is_empty()
	match type:
		Type.RESPONSE:
			body.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		Type.THOUGHT:
			body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_:
			body.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_source = text
	_paint(0)

func reveal(count: int) -> void:
	_paint(count)

func store() -> void:
	modulate = stored_modulate
	speaker_name.add_theme_font_size_override("font_size", stored_name_size)
	body.add_theme_font_size_override("normal_font_size", stored_body_size)
	_paint(_source.length())

func _paint(count: int) -> void:
	var n := clampi(count, 0, _source.length())
	var ink := _hex(_ink(), 1.0)
	var clear := _hex(_ink(), 0.0)
	body.text = "[color=%s]%s[/color][color=%s]%s[/color]" % [
		ink, _escape(_source.left(n)),
		clear, _escape(_source.substr(n)),
	]

func _ink() -> Color:
	return thought_color if type == Type.THOUGHT else ink_color

func _hex(color: Color, alpha: float) -> String:
	color.a = alpha
	return "#" + color.to_html(true)

func _escape(text: String) -> String:
	return text.replace("[", "[lb]").replace("]", "[rb]")
