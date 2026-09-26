class_name HouseSceneBase
extends Node

const ROOMS_NODE_NAME := "Rooms"


func _ready() -> void:
	InkFunctions.subscribe(self)


func load_room(room_name: String) -> void:
	var rooms := get_node_or_null(ROOMS_NODE_NAME)
	if rooms == null:
		printerr("HouseSceneBase: missing '%s' child" % ROOMS_NODE_NAME)
		return
	var found := false
	for child in rooms.get_children():
		if not child is RoomBase:
			continue
		var room := child as RoomBase
		var active := room.room_name == room_name
		room.visible = active
		if active:
			found = true
	if not found:
		printerr("HouseSceneBase: no room named '%s'" % room_name)
