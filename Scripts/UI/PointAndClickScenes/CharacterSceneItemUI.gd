class_name CharacterSceneItemUI
extends SceneItemUI

var _collision_ready := false

func _ready() -> void:
	var source := get_parent() as AnimatedSprite2D
	if source != null:
		source.frame_changed.connect(sync_frame)
		source.animation_changed.connect(sync_frame)
	_apply_current_frame()
	if texture == null:
		_init_scene_item()
		_area_2d.input_event.connect(_on_input_event)
		release()
		_collision_ready = true
		return
	super._ready()
	_collision_ready = true

func sync_frame() -> void:
	var previous := texture
	_apply_current_frame()
	if not _collision_ready or texture == null or texture == previous:
		return
	Area2DUtils.setup_collision_from_sprite(self, _area_2d)

func can_interact() -> bool:
	return get_effective_interaction_type() != INTERACTION_TYPE.NONE

func _apply_current_frame() -> void:
	var source := get_parent() as AnimatedSprite2D
	if source == null or source.sprite_frames == null:
		return
	if not source.sprite_frames.has_animation(source.animation):
		return
	var frame_tex := source.sprite_frames.get_frame_texture(source.animation, source.frame)
	if frame_tex == null:
		return
	centered = source.centered
	offset = source.offset
	texture = frame_tex
