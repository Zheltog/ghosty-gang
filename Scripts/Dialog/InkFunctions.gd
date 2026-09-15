extends Node

var _targets: Dictionary = {}
var _bound_story: InkStory

func subscribe(target: Object) -> void:
	if target == null:
		return
	var key := _class_key(target)
	if key.is_empty():
		printerr("InkFunctions: cannot subscribe target without a class_name")
		return
	if _targets.get(key) == target:
		return
	_targets[key] = target
	if target is Node:
		var node := target as Node
		node.tree_exiting.connect(_on_target_tree_exiting.bind(target), CONNECT_ONE_SHOT)

func unsubscribe(target: Object) -> void:
	if target == null:
		return
	var key := _class_key(target)
	if _targets.get(key) == target:
		_targets.erase(key)

func clear_targets() -> void:
	_targets.clear()

func bind_story(story: InkStory) -> void:
	if story == null or story == _bound_story:
		return
	_bound_story = story
	story.BindExternalFunction("godot", Callable(self, "_ink_godot"))
	story.BindExternalFunction("godot_1", Callable(self, "_ink_godot_1"))
	story.BindExternalFunction("godot_2", Callable(self, "_ink_godot_2"))

func _ink_godot(target_class: String, method: String) -> Variant:
	return _invoke(target_class, method, [])

func _ink_godot_1(target_class: String, method: String, arg) -> Variant:
	return _invoke(target_class, method, [arg])

func _ink_godot_2(target_class: String, method: String, arg0, arg1) -> Variant:
	return _invoke(target_class, method, [arg0, arg1])

func _invoke(target_class: String, method: String, args: Array) -> Variant:
	var target: Object = _targets.get(StringName(target_class))
	if target == null or not is_instance_valid(target):
		printerr("InkFunctions: no subscribed target for class '%s'" % target_class)
		return null
	if not target.has_method(method):
		printerr("InkFunctions: %s has no method '%s'" % [target_class, method])
		return null
	return target.callv(method, args)

func _class_key(target: Object) -> StringName:
	var script := target.get_script() as Script
	if script:
		var global_name := script.get_global_name()
		if global_name != &"":
			return global_name
	return StringName()

func _on_target_tree_exiting(target: Object) -> void:
	unsubscribe(target)
