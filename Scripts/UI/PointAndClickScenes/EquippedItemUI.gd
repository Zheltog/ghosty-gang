class_name EquippedItemUI
extends AnimatedSprite2D

var _play_once := false

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	set_ui_animation("default")

func set_ui_animation(animation: String) -> void:
	sprite_frames.set_animation_loop_mode(animation, SpriteFrames.LOOP_LINEAR)
	_play_once = false
	play(animation)

func play_ui_animations_once(animation: String) -> void:
	_play_once = true
	sprite_frames.set_animation_loop_mode(animation, SpriteFrames.LOOP_NONE)
	play(animation)

func _on_animation_finished() -> void:
	if not _play_once:
		return
	_play_once = false
	set_ui_animation("default")
