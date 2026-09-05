class_name MapPointCard

extends Control

@onready var _base = $Base
@onready var _name_label: Label = $Base/NameLabel
@onready var _description_label: Label = $Base/DescriptionLabel
@onready var _theses_label: Label = $Base/ThesesLabel

func _ready() -> void:
	$Base/BackButton.pressed.connect(_on_back_button_pressed)
	$Base/GoButton.pressed.connect(_on_go_button_pressed)
	_do_hide()

func _on_back_button_pressed() -> void:
	_do_hide()
	print("BACK")

func _on_go_button_pressed() -> void:
	_do_hide()
	print("GOING TO ", _name_label.text)

func open(id: String) -> void:
	_base.show()
	var map_point_config = MapPointConfigManager.load()
	_name_label.text = map_point_config.get_name_by_id(id)
	_description_label.text = map_point_config.get_description_by_id(id)
	var theses = ThesisConfigManager.get_theses_by_group_known(id)
	_theses_label.text = "\n".join(theses)

func _do_hide() -> void:
	_base.hide()
