class_name SceneDialogState
extends Node

@export var active := false
@export var next_options: Array[SceneDialogState]

var scene_dialog_manager: SceneDialogManager

func activate() -> void:
	active = true
	scene_dialog_manager.current_active = self

func activate_next(idx: int) -> void:
	if idx < 0 or idx >= next_options.size() or next_options[idx] == null:
		printerr("%s: no next state at %d" % [name, idx])
		return
	next_options[idx].activate()
	active = false

func _process(_delta: float) -> void:
	if not active:
		return
	var opt_idx := check_condition()
	if opt_idx >= 0:
		activate_next(opt_idx)

func process_event(_event: String) -> void:
	pass

func check_condition() -> int:
	return -1

func house() -> HouseScenePreview:
	return HouseSceneBase.current_house_scene as HouseScenePreview

## look_movement: scene items stay clickable for the whole story.
func play(path: String, look_movement: bool = true) -> void:
	var dialog := scene_dialog_manager.dialog_controller
	if dialog == null:
		printerr("%s: no DialogController" % name)
		return
	dialog.start_story(path, look_movement)

func flag(key: String) -> bool:
	return bool(InkVariableStore.get_value(key, false))

func suspicion() -> int:
	return int(InkVariableStore.get_value("suspicion", 0))

func store_arrival_flags() -> void:
	var shelf_open := bool(StateManager.get_state(CustomBookshelfSceneItemUI.STATE_OPEN, false))
	InkVariableStore.set_value("closet_open", shelf_open)

func play_looped(path: String, volume: int = 100) -> void:
	var command := AudioSoundLoopedCoomand.new()
	command.instant = true
	command.resource_name = path
	command.relative_volume = volume
	CommonAudioProcessor.process_sound_looped(command)

func stop_looped(path: String) -> void:
	if not CommonAudioProcessor.has_looped_sound(path):
		return
	var command := AudioSoundLoopedCoomand.new()
	command.instant = true
	command.resource_name = path
	command.post_action = AudioConstants.STOP
	CommonAudioProcessor.process_sound_looped(command)
