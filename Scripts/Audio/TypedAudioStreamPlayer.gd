class_name TypedAudioStreamPlayer

extends AudioStreamPlayer

@export var type: AudioStreamPlayerType

var _dynamicAdjustmentState: DynamicAdjustmentState
var _saved_volume: float
var _target_volume: float
var _changing_volume_time_elapsed: float = 0
var _changing_volume_duration: float = 0
var _saved_callback: Callable

func _process(delta: float) -> void:
	if _dynamicAdjustmentState == DynamicAdjustmentState.None:
		return
	if _changing_volume_time_elapsed < _changing_volume_duration:
		_changing_volume_time_elapsed += delta
		var percent = clamp(_changing_volume_time_elapsed / _changing_volume_duration, 0, 1)
		volume_linear = lerp(_saved_volume, _target_volume, percent)
	if _changing_volume_time_elapsed >= _changing_volume_duration:
		if _dynamicAdjustmentState == DynamicAdjustmentState.Falling and _saved_callback != null:
			_saved_callback.call()
		_dynamicAdjustmentState = DynamicAdjustmentState.None

func adjust_volume_instant() -> void:
	var max_volume = _get_max_volume()
	if abs(volume_linear - max_volume) > 0:
		volume_linear = max_volume

func adjust_volume_rising(seconds: float) -> void:
	if volume_linear > 0:
		volume_linear = 0
	_saved_volume = volume_linear
	_target_volume = _get_max_volume()
	_changing_volume_time_elapsed = 0
	_changing_volume_duration = seconds
	_dynamicAdjustmentState = DynamicAdjustmentState.Rising

func adjust_volume_falling(seconds: float, after_finished: Callable):
	_saved_callback = after_finished
	_saved_volume = volume_linear
	_target_volume = 0
	_changing_volume_time_elapsed = 0
	_changing_volume_duration = seconds
	_dynamicAdjustmentState = DynamicAdjustmentState.Falling

func _get_max_volume() -> float:
	match type:
		AudioStreamPlayerType.Music:
			return CommonAudioProcessor.music_volume / 100
		AudioStreamPlayerType.Sound:
			return CommonAudioProcessor.sound_volume / 100
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
