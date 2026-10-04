class_name CharacterSceneItemUI
extends SceneItemUI

const DRAW_Z := 1
const SHOOT_ACTION := "shoot"

var _collision_ready := false

func _ready() -> void:
	scene_item_id = SceneItemGenerator.SCENE_ITEM.NONE
	intercation_type = INTERACTION_TYPE.LOOK
	interact_during_dialog = true
	z_as_relative = false
	z_index = DRAW_Z
	modulate.a = 0.0
	_apply_current_frame()
	if texture == null:
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
	return _holding_gun()

func get_effective_interaction_type() -> INTERACTION_TYPE:
	if not _holding_gun():
		return INTERACTION_TYPE.NONE
	return INTERACTION_TYPE.SHOOT

func press_item() -> void:
	if not _holding_gun():
		return
	var scene := get_tree().current_scene
	if scene == null:
		return
	var dialog := NodeUtils.get_child_of_type(scene, DialogController) as DialogController
	if dialog == null:
		return
	dialog.try_action(SHOOT_ACTION)

func _holding_gun() -> bool:
	var equipped := _get_equipped_item()
	return equipped != null and equipped.inventory_item_id == InventoryItemGenerator.INVENTORY_ITEM.GUN

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
