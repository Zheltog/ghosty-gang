class_name HouseSceneBase
extends Node

static var current_house_scene: HouseSceneBase = null

const ROOMS_NODE_NAME := "Rooms"

@export var characters: Array[SceneCharacter] = []
@export var room_scenes: Array[PackedScene] = []

var current_room: String = ""

func _ready() -> void:
	current_house_scene = self
	_load_room_scenes()
	_collect_room_dependents()
	InkFunctions.subscribe(self)

func _load_room_scenes() -> void:
	if room_scenes.is_empty():
		return
	var rooms := get_node_or_null(ROOMS_NODE_NAME)
	if rooms == null:
		printerr("HouseSceneBase: missing '%s' child" % ROOMS_NODE_NAME)
		return
	for packed in room_scenes:
		if packed == null:
			continue
		rooms.add_child(packed.instantiate())

func _collect_room_dependents() -> void:
	var pending: Array[Node] = [self]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		if node is SceneParallaxController:
			node.collect()
		elif node is SceneObjectsManager:
			node.collect_scene_items()
		for child in node.get_children():
			pending.append(child)

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
		return
	current_room = room_name
	refresh_characters()

func refresh_characters() -> void:
	for character in characters:
		if character:
			character.refresh(true)

func set_characters_emotion(emotion: String) -> void:
	for character in characters:
		if character:
			character.set_emotion(emotion)
