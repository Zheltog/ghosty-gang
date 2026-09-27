class_name SceneCharacter
extends Node2D

@export var sprite: AnimatedSprite2D
@export var location: String = ""
@export var emotion: String = "idle"

func _ready() -> void:
	refresh()

func set_location(new_location: String) -> void:
	location = new_location
	refresh()

func set_emotion(new_emotion: String) -> void:
	emotion = new_emotion
	refresh()

func refresh() -> void:
	var house := HouseSceneBase.current_house_scene
	visible = house != null and location == house.current_room
	if sprite == null or sprite.sprite_frames == null:
		return
	var named := "%s_%s" % [location, emotion]
	if sprite.sprite_frames.has_animation(named):
		sprite.play(named)
	elif sprite.sprite_frames.has_animation(emotion):
		sprite.play(emotion)
