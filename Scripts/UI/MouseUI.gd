class_name MouseUI
extends Node

var _ICON_CURSOR = preload("res://Assets/Sprites/UI/MouseIcons/mouse_cursor.png")
var _ICON_EYE = preload("res://Assets/Sprites/UI/MouseIcons/mouse_eye.png")
var _ICON_HAND = preload("res://Assets/Sprites/UI/MouseIcons/mouse_hand.png")
var _ICON_IN = preload("res://Assets/Sprites/UI/MouseIcons/mouse_in.png")
var _ICON_OUT = preload("res://Assets/Sprites/UI/MouseIcons/mouse_out.png")
var _ICON_FOOT = preload("res://Assets/Sprites/UI/MouseIcons/mouse_foot.png")

enum MOUSE_ICON {
	CURSOR,
	HAND,
	EYE,
	IN,
	OUT,
	FOOT
}

const _HOTSPOT := Vector2(15, 15)

func _ready() -> void:
	pass
	# TODO: move somewhere else?
	#set_mouse_icon(MOUSE_ICON.CURSOR)

func set_mouse_icon(icon : MOUSE_ICON) -> void:
	match icon:
		MOUSE_ICON.CURSOR:
			Input.set_custom_mouse_cursor(_ICON_CURSOR)
		MOUSE_ICON.HAND:
			_set_offset_cursor(_ICON_HAND)
		MOUSE_ICON.EYE:
			_set_offset_cursor(_ICON_EYE)
		MOUSE_ICON.IN:
			_set_offset_cursor(_ICON_IN)
		MOUSE_ICON.OUT:
			_set_offset_cursor(_ICON_OUT)
		MOUSE_ICON.FOOT:
			_set_offset_cursor(_ICON_FOOT)
		_:
			printerr("MOUSE_ICON present in enum, but icon was not provided. Did you forget to add icon preload?")
			set_mouse_icon(MOUSE_ICON.CURSOR)

func _set_offset_cursor(texture : Texture2D) -> void:
	Input.set_custom_mouse_cursor(texture, Input.CURSOR_ARROW, _HOTSPOT)
