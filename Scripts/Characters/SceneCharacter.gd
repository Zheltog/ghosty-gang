class_name SceneCharacter
extends Node2D

@export var sprite: AnimatedSprite2D
@export var location: String = ""
@export var emotion: String = "stand_normal"
@export var character_name: String = ""
@export var has_voice: bool = true

@export var after_emotion : Dictionary

const EMOTION_POINTS := "CharacterPositions"

var previous_emotion = "stand_normal"

func _ready() -> void:
	if sprite == null:
		return
	sprite.animation_finished.connect(_on_animation_end)
	_attach_scene_item()

func _attach_scene_item() -> void:
	if not _scene_has_object_manager():
		return
	if sprite.get_node_or_null("CharacterSceneItem") != null:
		return
	sprite.z_as_relative = false
	sprite.z_index = CharacterSceneItemUI.DRAW_Z
	var item := CharacterSceneItemUI.new()
	item.name = "CharacterSceneItem"
	var area := Area2D.new()
	area.name = "Area2D"
	item.add_child(area)
	sprite.add_child(item)
	sprite.frame_changed.connect(item.sync_frame)
	sprite.animation_changed.connect(item.sync_frame)

func _scene_has_object_manager() -> bool:
	var root: Node = self
	var tree_root := get_tree().root
	while root.get_parent() != null and root.get_parent() != tree_root:
		root = root.get_parent()
	return not root.find_children("*", "SceneObjectsManager", true, false).is_empty()

func set_location(new_location: String) -> void:
	location = new_location
	refresh(true)

func set_emotion(new_emotion: String) -> void:
	previous_emotion = emotion
	emotion = new_emotion
	refresh(false)

func refresh(save_progress : bool) -> void:
	var house := HouseSceneBase.current_house_scene
	var player_location := ""
	if house != null:
		player_location = house.current_room
	var from_here := _has_from_view(player_location)
	if house != null:
		visible = location == player_location or from_here
	_snap_to_emotion_point()
	if sprite == null or sprite.sprite_frames == null:
		return
	if house == null:
		return
	var anim := "%s_from_%s_%s" % [location, player_location, emotion]
	if not from_here:
		var named := "%s_%s" % [location, emotion]
		if sprite.sprite_frames.has_animation(named):
			anim = named
		elif sprite.sprite_frames.has_animation(emotion):
			anim = emotion
		else:
			printerr("SceneCharacter '%s': no animation for emotion '%s'" % [character_name, emotion])
			return
	if save_progress:
		change_current_animation(anim)
	else:
		sprite.play(anim)
	if sprite != self:
		sprite.show()

func _has_from_view(player_location: String) -> bool:
	if sprite == null or sprite.sprite_frames == null:
		return false
	if location.is_empty() or player_location == location:
		return false
	var anim := "%s_from_%s_%s" % [location, player_location, emotion]
	return sprite.sprite_frames.has_animation(anim)

func _snap_to_emotion_point() -> void:
	var root := _emotion_point_root()
	if root == null:
		return
	var holder := root.get_node_or_null(EMOTION_POINTS)
	if holder == null:
		return
	var point := _resolve_emotion_point(holder)
	if point == null:
		return
	var target: Node2D = sprite if sprite != null else self
	target.global_position = point.global_position
	target.global_scale = point.global_scale
	var parallax := target.get_node_or_null("ParallaxComponent") as ParallaxComponent
	if parallax != null:
		parallax.rest_position = target.position

func _emotion_point_root() -> Node:
	var house := HouseSceneBase.current_house_scene
	if house != null and is_inside_tree() and house.is_ancestor_of(self):
		var rooms := house.get_node_or_null(HouseSceneBase.ROOMS_NODE_NAME)
		if rooms == null:
			return null
		for child in rooms.get_children():
			if child is RoomBase and (child as RoomBase).room_name == house.current_room:
				return child
		return null
	if not is_inside_tree():
		return null
	return get_tree().current_scene

func _resolve_emotion_point(holder: Node) -> Node2D:
	var char_id := character_name.strip_edges().to_lower()
	var emotion_id := emotion.strip_edges().to_lower()
	var candidates: Array[String] = []
	if not char_id.is_empty() and not emotion_id.is_empty():
		candidates.append("%s_%s" % [char_id, emotion_id])
	if not char_id.is_empty():
		candidates.append("%s_default" % char_id)
	candidates.append("default")
	for candidate in candidates:
		var point := _child_named(holder, candidate)
		if point != null:
			return point
	return null

func _child_named(holder: Node, node_name: String) -> Node2D:
	for child in holder.get_children():
		if child is Node2D and str(child.name).to_lower() == node_name:
			return child
	return null

func change_current_animation(anim : String) -> void:
	var current_frame = sprite.get_frame()
	var current_progress = sprite.get_frame_progress()
	sprite.play(anim)
	sprite.set_frame_and_progress(current_frame, current_progress)

# whenever emotion or movement ends we go to the next emotion based on after_emotion dictionary
func _on_animation_end() -> void:
	if not after_emotion.has(emotion):
		return
	var next = after_emotion[emotion] as String
	if next == "_prev_":
		next = previous_emotion
	set_emotion(next)
