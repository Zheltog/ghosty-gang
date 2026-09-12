class_name RoomDescriptor

var id: String
var forward_id: String
var back_id: String
var left_id: String
var right_id: String
var content_scene_name: String

func _init(source: Dictionary) -> void:
	id = source.get("id", "")
	forward_id = source.get("forward", "")
	back_id = source.get("back", "")
	left_id = source.get("left", "")
	right_id = source.get("right", "")
	content_scene_name = source.get("scene", "")
