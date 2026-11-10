class_name MouseUI
extends Node

var _ICON_CURSOR = preload("res://Assets/Sprites/UI/MouseIcons/mouse_cursor_new.png")
var _ICON_EYE = preload("res://Assets/Sprites/UI/MouseIcons/mouse_eye_new.png")
var _ICON_HAND = preload("res://Assets/Sprites/UI/MouseIcons/mouse_hand_new.png")
var _ICON_IN = preload("res://Assets/Sprites/UI/MouseIcons/mouse_in.png")
var _ICON_OUT = preload("res://Assets/Sprites/UI/MouseIcons/mouse_out.png")
var _ICON_MOVE = preload("res://Assets/Sprites/UI/MouseIcons/mouse_move_new.png")
var _ICON_SHOOT = preload("res://Assets/Sprites/UI/MouseIcons/mouse_shoot_new.png")
var _ICON_KEY = preload("res://Assets/Sprites/UI/MouseIcons/mouse_key_new.png")

enum MOUSE_ICON {
	CURSOR,
	HAND,
	EYE,
	IN,
	OUT,
	MOVE,
	SHOOT,
	KEY
}

const _HOTSPOT_CENTER := Vector2(15, 15)
const _HOTSPOT_CURSOR := Vector2(2, 2)
const _HOTSPOT_HAND := Vector2(10, 6)
const _HOTSPOT_KEY := Vector2(2, 2)

func _ready() -> void:
	# Документация Viewport: без этого клик идёт в случайном порядке и не смотрит на z_index.
	get_viewport().physics_object_picking_sort = true
	# TODO: move somewhere else?
	#set_mouse_icon(MOUSE_ICON.CURSOR)

func set_mouse_icon(icon : MOUSE_ICON) -> void:
	match icon:
		MOUSE_ICON.CURSOR:
			Input.set_custom_mouse_cursor(_ICON_CURSOR, Input.CURSOR_ARROW, _HOTSPOT_CURSOR)
		MOUSE_ICON.HAND:
			Input.set_custom_mouse_cursor(_ICON_HAND, Input.CURSOR_ARROW, _HOTSPOT_HAND)
		MOUSE_ICON.EYE:
			Input.set_custom_mouse_cursor(_ICON_EYE, Input.CURSOR_ARROW, _HOTSPOT_CENTER)
		MOUSE_ICON.IN:
			Input.set_custom_mouse_cursor(_ICON_IN, Input.CURSOR_ARROW, _HOTSPOT_CENTER)
		MOUSE_ICON.OUT:
			Input.set_custom_mouse_cursor(_ICON_OUT, Input.CURSOR_ARROW, _HOTSPOT_CENTER)
		MOUSE_ICON.MOVE:
			Input.set_custom_mouse_cursor(_ICON_MOVE, Input.CURSOR_ARROW, _HOTSPOT_CENTER)
		MOUSE_ICON.SHOOT:
			Input.set_custom_mouse_cursor(_ICON_SHOOT, Input.CURSOR_ARROW, _HOTSPOT_CENTER)
		MOUSE_ICON.KEY:
			Input.set_custom_mouse_cursor(_ICON_KEY, Input.CURSOR_ARROW, _HOTSPOT_KEY)
		_:
			printerr("MOUSE_ICON present in enum, but icon was not provided. Did you forget to add icon preload?")
			set_mouse_icon(MOUSE_ICON.CURSOR)
