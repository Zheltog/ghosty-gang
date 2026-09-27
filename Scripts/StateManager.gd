extends Node

var _states: Dictionary = {}

func set_state(key: String, value: Variant = true) -> void:
	_states[key] = value

func get_state(key: String, default: Variant = null) -> Variant:
	return _states.get(key, default)

func clear_state(key: String = "") -> void:
	if key.is_empty():
		_states.clear()
	else:
		_states.erase(key)
