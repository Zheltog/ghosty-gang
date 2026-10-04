class_name HouseScenePreview
extends HouseSceneBase

@onready var dialog_controller: DialogController = $DialogController
@onready var scene_object_manager: SceneObjectsManager = $SceneObjectManager

const WATER_SOUND := "res://Assets/Audio/Sounds/water_kitchen.mp3"
const HUM_MUSIC := "res://Assets/Audio/Music/hum.wav"
const KITCHEN_THOUGHT := "res://Files/SceneDialogs/Ink/kitchen_busy.ink"
const WATER_DELAY := 5.0
const HUM_FADE_SECONDS := 3.0
const ENGINEER_RETURN_SECONDS := 6.0

@export var ink_dialog_appear_path : String

var ghost: Node2D
var _gun_drawn := false

func _ready() -> void:
	StateManager.clear_state()
	super._ready()
	ghost = get_node_or_null("Rooms/Kitchen/Ghost") as Node2D
	lock_room("kitchen", _kitchen_blocked)
	load_room("preroom")
	CommonAudioProcessor.transition_music(SceneLoader.DAY_MUSIC)
	dialog_controller.story_finished.connect(_on_story_finished)
	engineer_appear()
	if ink_dialog_appear_path.is_empty():
		printerr("HouseScenePreview: ink_dialog_appear_path is empty")
		return
	dialog_controller.start_story.call_deferred(ink_dialog_appear_path)

func load_room(room_name: String) -> void:
	super.load_room(room_name)
	if scene_object_manager and current_room == room_name:
		scene_object_manager.update_mouse_cursor()

func _kitchen_blocked() -> void:
	if DialogController.is_dialog_active():
		return
	dialog_controller.start_story(KITCHEN_THOUGHT)

func set_gun_drawn(drawn: bool) -> void:
	if _gun_drawn == drawn:
		return
	_gun_drawn = drawn
	if drawn:
		CommonAudioProcessor.transition_music(HUM_MUSIC)
	else:
		CommonAudioProcessor.transition_music(SceneLoader.DAY_MUSIC)

func _on_story_finished(story_name: String) -> void:
	if story_name != "inside_house":
		return
	_engineer_leaves_for_tea()

func _engineer_leaves_for_tea() -> void:
	if characters.is_empty() or characters[0] == null:
		return
	characters[0].set_location("kitchen")
	await get_tree().create_timer(WATER_DELAY).timeout
	if not is_inside_tree():
		return
	var command := AudioSoundLoopedCoomand.new()
	command.instant = true
	command.resource_name = WATER_SOUND
	command.relative_volume = 80
	CommonAudioProcessor.process_sound_looped(command)

func notice_passports() -> void:
	EngineerDialogs.mark_passports_seen()
	CommonAudioProcessor.transition_music(HUM_MUSIC, HUM_FADE_SECONDS)

func silence_kitchen() -> void:
	if not CommonAudioProcessor.has_looped_sound(WATER_SOUND):
		return
	var command := AudioSoundLoopedCoomand.new()
	command.instant = true
	command.resource_name = WATER_SOUND
	command.post_action = AudioConstants.STOP
	CommonAudioProcessor.process_sound_looped(command)

func schedule_engineer_arrival() -> void:
	if dialog_controller == null or dialog_controller.timer == null:
		printerr("HouseScenePreview: dialog has no GameTimer")
		return
	dialog_controller.timer.start(ENGINEER_RETURN_SECONDS, _on_engineer_return_timer, true)

func _on_engineer_return_timer() -> void:
	if not is_inside_tree():
		return
	if characters.is_empty() or characters[0] == null:
		printerr("HouseScenePreview: no engineer character configured")
		return
	var engineer := characters[0]
	var characters_root := engineer.get_parent()
	if characters_root:
		characters_root.visible = true
	engineer.set_location("living_room")

func engineer_appear() -> void:
	if characters.is_empty() or characters[0] == null:
		printerr("HouseScenePreview: no engineer character configured")
		return
	var engineer := characters[0]
	var characters_root := engineer.get_parent()
	if characters_root:
		characters_root.visible = true
	engineer.set_location("preroom")

func ghost_appear() -> void:
	if ghost:
		ghost.show()
