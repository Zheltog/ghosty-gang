class_name SceneCharacter
extends Node2D

@export var sprite: AnimatedSprite2D
@export var location: String = ""
@export var emotion: String = "idle"

@export var after_emotion : Dictionary

var previous_emotion = "idle"

func _ready() -> void:
	sprite.animation_finished.connect(_on_animation_end)

func set_location(new_location: String) -> void:
	location = new_location
	refresh(true)

func set_emotion(new_emotion: String) -> void:
	previous_emotion = emotion
	emotion = new_emotion
	refresh(false)

func refresh(save_progress : bool) -> void:
	var house := HouseSceneBase.current_house_scene
	visible = house != null and location == house.current_room
	if sprite == null or sprite.sprite_frames == null:
		return
	var player_location := house.current_room
	var anim := "%s_from_%s_%s" % [location, player_location, emotion]
	if sprite.sprite_frames.has_animation(anim):
		if save_progress:
			change_current_animation(anim)
		else:
			sprite.play(anim)
		sprite.show()
	else:
		sprite.hide()

func change_current_animation(anim : String) -> void:
	var current_frame = sprite.get_frame()
	var current_progress = sprite.get_frame_progress()
	sprite.play(anim)
	sprite.set_frame_and_progress(current_frame, current_progress)

# whenever emotion or movement ends we go to the next emotion based on after_emotion dictionary
func _on_animation_end() -> void:
	var next = after_emotion[emotion] as String
	if next == "_prev_":
		next = previous_emotion
	set_emotion(next)
