extends Node

var _states: Dictionary = {}
# Survives clear_state() and scene changes. Written into the day checkpoint.
var _global_state: Dictionary = {}

func set_state(key: String, value: Variant = true) -> void:
	_states[key] = value

func get_state(key: String, default: Variant = null) -> Variant:
	return _states.get(key, default)

func clear_state(key: String = "") -> void:
	if key.is_empty():
		_states.clear()
	else:
		_states.erase(key)

func set_global_state(key: String, value: Variant = true) -> void:
	_global_state[key] = value

func get_global_state(key: String, default: Variant = null) -> Variant:
	return _global_state.get(key, default)

func export_global_state() -> Dictionary:
	return _global_state.duplicate(true)

func restore_global_state(state: Dictionary) -> void:
	_global_state = state.duplicate(true)
