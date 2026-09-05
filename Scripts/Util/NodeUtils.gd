class_name NodeUtils

static func get_child_of_type(parent, type) -> Node:
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null
