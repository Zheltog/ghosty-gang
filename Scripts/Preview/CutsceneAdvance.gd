extends Node2D

@export var next_scene: SceneLoader.SCENE = SceneLoader.SCENE.NONE
@export var advance_on_click: bool = true
@export var advance_when_animation_finished: bool = true

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if _animated_sprite.sprite_frames and _animated_sprite.sprite_frames.has_animation("cutscene"):
		_animated_sprite.play("cutscene")
	if advance_when_animation_finished:
		_animated_sprite.animation_finished.connect(_advance)

func _unhandled_input(event: InputEvent) -> void:
	if not advance_on_click:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_advance()
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			_advance()

func _advance() -> void:
	if next_scene == SceneLoader.SCENE.NONE:
		return
	SceneLoader.change_scene(next_scene)
