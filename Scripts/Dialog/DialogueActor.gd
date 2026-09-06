class_name DialogueActor

extends Node

@export var animation_player: AnimationPlayer
@export var default_animation_name: StringName = &"idle"

func play_dialogue_animation(animation_name: StringName) -> void:
	if animation_player == null:
		push_warning("DialogueActor has no AnimationPlayer assigned.")
		return

	var requested_animation := animation_name
	if requested_animation == &"":
		requested_animation = default_animation_name

	if requested_animation == &"":
		return

	if animation_player.current_animation == requested_animation and animation_player.is_playing():
		return

	if animation_player.has_animation(requested_animation):
		animation_player.play(requested_animation)
		return

	push_warning("Dialogue animation '%s' does not exist." % requested_animation)

	if (
		requested_animation != default_animation_name
		and default_animation_name != &""
		and animation_player.has_animation(default_animation_name)
	):
		animation_player.play(default_animation_name)
