class_name GameTimer

extends Control

@onready var _label: Label = $Label
@onready var _timer: Timer = $Timer

var _last_time_displayed: int = 0

func _process(delta: float) -> void:
	if (_timer.time_left as int) != _last_time_displayed:
		_display_remaining_time()

func start(seconds: float, callback: Callable) -> void:
	_timer.start(seconds)
	_timer.timeout.connect(callback)

func reset() -> void:
	_timer.stop()
	_last_time_displayed = 0
	_label.text = "--:--"

func is_ticking() -> bool:
	return _timer.time_left != 0

func _display_remaining_time() -> void:
	var time_left_int = _timer.time_left as int
	if time_left_int == 0:
		_label.text = "00:00"
		return
	var remaining_seconds = time_left_int
	var remaining_minutes = remaining_seconds / 60
	if remaining_minutes > 99:
		printerr("[GameTimer] Could not represent more than 99 remaining minutes")
		return
	remaining_seconds = remaining_seconds - remaining_minutes * 60
	var minutes_representation = str(remaining_minutes) if remaining_minutes >= 10 else str("0", remaining_minutes)
	var seconds_representation = str(remaining_seconds) if remaining_seconds >= 10 else str("0", remaining_seconds)
	_label.text = str(minutes_representation, ":", seconds_representation)
	_last_time_displayed = time_left_int
