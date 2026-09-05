class_name MouseUI
extends Node

var _ICON_CURSOR = preload("res://Assets/Sprites/UI/MouseIcons/mouse_cursor.png")
var _ICON_EYE = preload("res://Assets/Sprites/UI/MouseIcons/mouse_eye.png")
var _ICON_HAND = preload("res://Assets/Sprites/UI/MouseIcons/mouse_hand.png")

enum MOUSE_ICON {
	CURSOR,
	HAND,
	EYE
}

func _ready() -> void:
	# TODO: move somewhere else?
	set_mouse_icon(MOUSE_ICON.CURSOR)

func set_mouse_icon(icon : MOUSE_ICON) -> void:
	match icon:
		MOUSE_ICON.CURSOR:
			Input.set_custom_mouse_cursor(_ICON_CURSOR)
			return
		MOUSE_ICON.HAND:
			Input.set_custom_mouse_cursor(_ICON_HAND)
			return
		MOUSE_ICON.EYE:
			Input.set_custom_mouse_cursor(_ICON_EYE)
			return
	printerr("MOUSE_ICON present in enum, but icon was not provided. Did you forget to add icon preload?")
	set_mouse_icon(_ICON_CURSOR)
