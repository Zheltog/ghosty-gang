class_name DialogPhrase

extends VBoxContainer

enum Type { REPLICA, RESPONSE, THOUGHT }

@export var type: Type = Type.REPLICA
@export var thought_color: Color = Color(0.70, 0.78, 0.88)
@export var stored_modulate: Color = Color(0.7, 0.7, 0.7)
@export var stored_name_size: int = 28
@export var stored_body_size: int = 32

@onready var speaker_name: Label = $Name
@onready var body: RichTextLabel = $Body

func present(text: String, who: String = "") -> void:
	speaker_name.text = who
	speaker_name.visible = type == Type.REPLICA and not who.is_empty()
	match type:
		Type.RESPONSE:
			body.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		Type.THOUGHT:
			body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			body.add_theme_color_override("default_color", thought_color)
		_:
			body.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	body.text = text
	body.visible_characters = 0
	_fit()
	call_deferred("_fit")

func reveal(count: int) -> void:
	body.visible_characters = count

func store() -> void:
	modulate = stored_modulate
	speaker_name.add_theme_font_size_override("font_size", stored_name_size)
	body.add_theme_font_size_override("normal_font_size", stored_body_size)
	_fit()
	call_deferred("_fit")

func _fit() -> void:
	var shown := body.visible_characters
	body.visible_characters = -1
	if size.x > 0.0:
		body.size.x = size.x
	var lines := maxi(body.get_line_count(), 1)
	var font := body.get_theme_font("normal_font")
	var font_size := body.get_theme_font_size("normal_font_size")
	var line_height := font.get_height(font_size) if font else float(font_size)
	body.custom_minimum_size.y = ceili(line_height * lines)
	body.visible_characters = shown
