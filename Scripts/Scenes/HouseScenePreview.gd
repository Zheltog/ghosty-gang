class_name HouseScenePreview
extends HouseSceneBase

@onready var dialog_controller: DialogController = $DialogController
@onready var scene_object_manager: SceneObjectsManager = $SceneObjectManager

const WATER_SOUND := "res://Assets/Audio/Sounds/water_kitchen.mp3"
const FIRE_SOUND := "res://Assets/Audio/Sounds/fire.mp3"
const HUM_MUSIC := "res://Assets/Audio/Music/hum.wav"
const NIGHT_MUSIC := "res://Assets/Audio/Music/Ночь.mp3"
const KITCHEN_THOUGHT := "res://Files/SceneDialogs/Ink/kitchen_busy.ink"
const ENGINEER_RETURN := "res://Files/SceneDialogs/Ink/engineer_return.ink"
const WATER_DELAY := 5.0
const HUM_FADE_SECONDS := 3.0
const STORAGE_HUM_FADE_SECONDS := 8.0
const NIGHT_FADE_SECONDS := 8.0
const ENGINEER_RETURN_SECONDS := 6.0
const RETURN_TIMER_DELAY := 2.0
const FIRE_DELAY := 10.0
const INSIDE_ROOMS: Array[String] = ["storage", "exit_from_storage"]

@export var ink_dialog_appear_path : String

var ghost: Node2D
var _gun_drawn := false
var _storage_hum := false

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
	_try_resume_tea_after_rag()

func reveal_rag() -> void:
	_set_room_child_visible("bathroom", "Rag", true)

func reveal_tea() -> void:
	_set_room_child_visible("kitchen_couch", "Tea", true)

func engineer_wait_in_kitchen() -> void:
	unlock_room("kitchen")
	_engineer_awaits_tea = true
	_kitchen_sit_said = false
	if characters.is_empty() or characters[0] == null:
		printerr("HouseScenePreview: no engineer character configured")
		return
	var engineer := characters[0]
	engineer.set_emotion("stand_tea")
	engineer.set_location("kitchen")

func _on_entered_room(room_name: String) -> void:
	if not _engineer_awaits_tea or DialogController.is_dialog_active():
		return
	if room_name == "kitchen" and not _kitchen_sit_said:
		_kitchen_sit_said = true
		dialog_controller.start_story(ENGINEER_SIT)
		return
	if room_name != "kitchen_couch":
		return
	_engineer_awaits_tea = false
	if characters.is_empty() or characters[0] == null:
		printerr("HouseScenePreview: no engineer character configured")
		return
	characters[0].set_location("kitchen_couch")
	EngineerDialogs.tea()

func _kitchen_blocked() -> void:
	if DialogController.is_dialog_active():
		return
	dialog_controller.start_story(KITCHEN_THOUGHT)

func set_gun_drawn(drawn: bool) -> void:
	if _gun_drawn == drawn:
		return
	_gun_drawn = drawn
	EngineerDialogs.set_gun_drawn(drawn)
	if drawn:
		CommonAudioProcessor.transition_music(HUM_MUSIC)
	elif not _storage_hum:
		CommonAudioProcessor.transition_music(SceneLoader.DAY_MUSIC)

func on_storage_opened() -> void:
	if _storage_hum:
		return
	_storage_hum = true
	CommonAudioProcessor.transition_music(HUM_MUSIC, STORAGE_HUM_FADE_SECONDS)

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
	if _storage_hum:
		return
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
	get_tree().create_timer(RETURN_TIMER_DELAY).timeout.connect(
		_start_engineer_return_timer, CONNECT_ONE_SHOT
	)

func _start_engineer_return_timer() -> void:
	if not is_inside_tree():
		return
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
	CommonAudioProcessor.transition_music(NIGHT_MUSIC, NIGHT_FADE_SECONDS)
	if _player_inside_storage():
		_store_return_flags()
		_seal_storage()
		_start_trapped_fire()
		EngineerDialogs.trapped()
		return
	engineer.set_emotion("stand_tea")
	_store_return_flags()
	load_room("living_room")
	EngineerDialogs.play(ENGINEER_RETURN)

func _player_inside_storage() -> bool:
	return INSIDE_ROOMS.has(current_room)

func _store_return_flags() -> void:
	var shelf_open := bool(StateManager.get_state(CustomBookshelfSceneItemUI.STATE_OPEN, false))
	EngineerDialogs.set_closet_open(shelf_open)
	EngineerDialogs.set_gun_drawn(_gun_drawn)

func _seal_storage() -> void:
	var shelf := find_child("Shelfs", true, false) as CustomBookshelfSceneItemUI
	if shelf:
		shelf.lock_closed()
	else:
		StateManager.set_state(CustomBookshelfSceneItemUI.STATE_OPEN, false)
		StateManager.set_state(CustomBookshelfSceneItemUI.STATE_LOCKED, true)
	_set_room_child_visible("storage", "ToLivingRoom", false)
	_set_room_child_visible("exit_from_storage", "ToLivingRoomToExit", false)
	_set_room_child_visible("exit_from_storage", "ExitLocked", true)
	lock_room("living_room", _stay_inside)
	lock_room("living_room_to_exit", _stay_inside)
	lock_room("living_room_2", _stay_inside)
	lock_room("bookshelf", _stay_inside)

func _stay_inside() -> void:
	pass

func _set_room_child_visible(room_name: String, child_name: String, shown: bool) -> void:
	var rooms := get_node_or_null(ROOMS_NODE_NAME)
	if rooms == null:
		return
	for child in rooms.get_children():
		if not child is RoomBase or (child as RoomBase).room_name != room_name:
			continue
		var node := child.get_node_or_null(child_name)
		if node is CanvasItem:
			(node as CanvasItem).visible = shown
		return

func _start_trapped_fire() -> void:
	await get_tree().create_timer(FIRE_DELAY).timeout
	if not is_inside_tree():
		return
	var command := AudioSoundLoopedCoomand.new()
	command.instant = true
	command.resource_name = FIRE_SOUND
	CommonAudioProcessor.process_sound_looped(command)

func _try_resume_tea_after_rag() -> void:
	if current_room != "living_room":
		return
	if not bool(InkVariableStore.get_value("fetching_rag", false)):
		return
	if DialogController.is_dialog_active():
		return
	var inventory := scene_object_manager.inventory if scene_object_manager else null
	if inventory == null or not inventory.has_item(InventoryItemGenerator.INVENTORY_ITEM.RAG):
		return
	inventory.remove_item(InventoryItemGenerator.INVENTORY_ITEM.RAG)
	InkVariableStore.set_value("fetching_rag", false)
	InkVariableStore.set_value("rag_fetched", true)
	EngineerDialogs.tea.call_deferred()

func engineer_appear() -> void:
	if characters.is_empty() or characters[0] == null:
		printerr("HouseScenePreview: no engineer character configured")
		return
	var engineer := characters[0]
	var characters_root := engineer.get_parent()
	if characters_root:
		characters_root.visible = true
	engineer.set_location("preroom")
