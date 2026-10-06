class_name BlackoutEffect
extends TextureRect

const _ANIM := &"blackout"

@onready var _player: AnimationPlayer = $AnimationPlayer

func effect_blackout() -> void:
	show()
	_player.play(_ANIM)
	await _player.animation_finished

func back_to_normal() -> void:
	if modulate.a <= 0.0 and not _player.is_playing():
		return
	show()
	_player.play_backwards(_ANIM)
	await _player.animation_finished
