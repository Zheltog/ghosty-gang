class_name TypedAudioStreamPlayer

extends AudioStreamPlayer

const _default_volume_change_seconds: float = 1
const _default_volume_changing_speed: float = 0.5

@export var type: AudioStreamPlayerType

var _resource_name: String
var _adjustment_mode: AdjustmentMode
var _dynamicAdjustmentState: DynamicAdjustmentState
var _saved_volume: float
var _target_volume: float
var _saved_callback: Callable
# by time
var _changing_volume_time_elapsed: float = 0
var _changing_volume_duration: float = 0
# by speed
var _changing_volume_speed: float = 1

func _process(delta: float) -> void:
	if _dynamicAdjustmentState == DynamicAdjustmentState.None:
		return
	match _adjustment_mode:
		AdjustmentMode.BY_TIME:
			_process_adjustment_by_time(delta)
		AdjustmentMode.BY_SPEED:
			_process_adjustment_by_speed(delta)
		_:
			printerr("[TypedAudioStreamPlayer] No adjustment mode specified")

func _process_adjustment_by_time(delta: float) -> void:
	if _changing_volume_time_elapsed < _changing_volume_duration:
		_changing_volume_time_elapsed += delta
		var percent = clamp(_changing_volume_time_elapsed / _changing_volume_duration, 0, 1)
		volume_linear = lerp(_saved_volume, _target_volume, percent)
	if _changing_volume_time_elapsed >= _changing_volume_duration:
		if _dynamicAdjustmentState == DynamicAdjustmentState.Falling and _saved_callback != null:
			_saved_callback.call()
		_dynamicAdjustmentState = DynamicAdjustmentState.None

func _process_adjustment_by_speed(delta: float) -> void:
	var multiplier = 1 if _target_volume > _saved_volume else -1
	volume_linear += multiplier * _changing_volume_speed * delta
	if (multiplier == 1 and volume_linear >= _target_volume) or (multiplier == -1 and volume_linear <= _target_volume):
		volume_linear = _target_volume 
		if _dynamicAdjustmentState == DynamicAdjustmentState.Falling and _saved_callback != null:
			_saved_callback.call()
		_dynamicAdjustmentState = DynamicAdjustmentState.None

func play_resource(resource_name: String, resource_stream: AudioStream) -> void:
	_resource_name = resource_name
	stream = resource_stream
	play()

func adjust_volume_instant() -> void:
	var max_volume = _get_max_volume()
	if abs(volume_linear - max_volume) > 0:
		volume_linear = max_volume

func adjust_volume_rising(adjustment_mode: AdjustmentMode, adjustment_value: float) -> void:
	if volume_linear > 0:
		volume_linear = 0
	_saved_volume = volume_linear
	_target_volume = _get_max_volume()
	_set_changing_values(adjustment_mode, adjustment_value)
	_dynamicAdjustmentState = DynamicAdjustmentState.Rising

func adjust_volume_falling(adjustment_mode: AdjustmentMode, adjustment_value: float, after_finished: Callable) -> void:
	_saved_callback = after_finished
	_saved_volume = volume_linear
	_target_volume = 0
	_set_changing_values(adjustment_mode, adjustment_value)
	_dynamicAdjustmentState = DynamicAdjustmentState.Falling

func _set_changing_values(adjustment_mode: AdjustmentMode, adjustment_value: float) -> void:
	_adjustment_mode = adjustment_mode
	match _adjustment_mode:
		AdjustmentMode.BY_TIME:
			_changing_volume_time_elapsed = 0
			_changing_volume_duration = adjustment_value if adjustment_value > 0 else _default_volume_change_seconds
		AdjustmentMode.BY_SPEED:
			_changing_volume_speed = adjustment_value if adjustment_value > 0 else _default_volume_changing_speed

func _get_max_volume() -> float:
	var relative_volume = CommonAudioProcessor.relative_volumes.get(_resource_name, 100)
	match type:
		AudioStreamPlayerType.Music:
			return (relative_volume / 100) * (CommonAudioProcessor.music_volume / 100)
		AudioStreamPlayerType.Sound:
			return (relative_volume / 100) * (CommonAudioProcessor.sound_volume / 100)
		_:
			printerr("[TypedAudioStreamPlayer] Unknown type: ", type)
			return -1

func _on_adjustment_finished(after_finished: Callable):
	if _dynamicAdjustmentState == DynamicAdjustmentState.Rising:
		adjust_volume_instant()
	_dynamicAdjustmentState = DynamicAdjustmentState.None
	after_finished.call()

enum AudioStreamPlayerType
{
	Music, Sound
}

enum DynamicAdjustmentState
{
	Rising, Falling, None
}

enum AdjustmentMode
{
	BY_TIME, BY_SPEED
}
