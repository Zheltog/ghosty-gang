class_name EngineerDialog
extends Node

const ROAD := "res://Files/SceneDialogs/Ink/engineer_road.ink"
const RETURNED := "res://Files/SceneDialogs/Ink/engineer_return.ink"
const TRAPPED := "res://Files/SceneDialogs/Ink/engineer_trap.ink"
const TEA := "res://Files/SceneDialogs/Ink/engineer_tea.ink"
const INTERVIEW := "res://Files/SceneDialogs/Ink/engineer_interview.ink"
const NIGHT := "res://Files/SceneDialogs/Ink/engineer_night.ink"
const MORNING := "res://Files/SceneDialogs/Ink/engineer_morning.ink"
const TORTURE := "res://Files/SceneDialogs/Ink/engineer_torture.ink"
const TORTURE_MUSIC := "res://Assets/Audio/Music/FUCK.mp3"
const STREET := "res://Files/SceneDialogs/Ink/engineer_street.ink"

func _ready() -> void:
	InkFunctions.subscribe(self)

func road() -> void:
	_start(ROAD)

func returned() -> void:
	_start(RETURNED)

func play(path: String) -> void:
	_start(path)

func trapped() -> void:
	_start(TRAPPED)

func tea() -> void:
	_start(TEA)

func interview() -> void:
	_start(INTERVIEW)

func night() -> void:
	_start(NIGHT)

func morning() -> void:
	_start(MORNING)

func torture() -> void:
	CommonAudioProcessor.transition_music(TORTURE_MUSIC)
	_start(TORTURE)

func street() -> void:
	_start(STREET)

func mark_closet_open() -> void:
	set_closet_open(true)

func set_closet_open(open: bool) -> void:
	InkVariableStore.set_value("closet_open", open)

func set_gun_drawn(drawn: bool) -> void:
	InkVariableStore.set_value("gun_drawn", drawn)

func mark_passports_seen() -> void:
	InkVariableStore.set_value("saw_passports", true)

func mark_glass_eye() -> void:
	InkVariableStore.set_value("has_glass_eye", true)

func _start(path: String) -> void:
	var dialog := _dialog()
	if dialog == null:
		printerr("EngineerDialog: no DialogController")
		return
	if not dialog.story_finished.is_connected(_on_story_finished):
		dialog.story_finished.connect(_on_story_finished)
	dialog.start_story(path)

func _on_story_finished(story_name: String) -> void:
	match story_name:
		"engineer_return":
			if _flag("engineer_dead"):
				street.call_deferred()
			else:
				tea.call_deferred()
		"engineer_tea":
			if _flag("engineer_dead") or _flag("engineer_kicked"):
				street.call_deferred()
			elif _flag("engineer_poison"):
				torture.call_deferred()
			else:
				interview.call_deferred()
		"engineer_interview":
			if _flag("engineer_dead"):
				street.call_deferred()
			elif _flag("engineer_sleep"):
				night.call_deferred()
		"engineer_night":
			morning.call_deferred()
		"engineer_morning":
			if _flag("engineer_to_torture"):
				torture.call_deferred()
			elif _flag("engineer_dead") or _flag("engineer_leave"):
				street.call_deferred()

func _flag(key: String) -> bool:
	return bool(InkVariableStore.get_value(key, false))

func _dialog() -> DialogController:
	var scene := get_tree().current_scene
	if scene == null:
		return null
	return NodeUtils.get_child_of_type(scene, DialogController) as DialogController
