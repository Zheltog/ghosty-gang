class_name GameTimer

extends Control

@onready var _bar: TextureRect = $Bar
@onready var _label: Label = $Label
@onready var _timer: Timer = $Timer

var _last_time_displayed: int = 0
var _start_seconds : float = 0.0
var _persist := false


func _ready() -> void:
	_set_inactive()

func _process(_delta: float) -> void:
	_display_remaining_time()

func start(seconds: float, callback: Callable, persist: bool = false) -> void:
	_stop_timer()
	_persist = persist
	_start_seconds = seconds
	_timer.start(seconds)
	_timer.timeout.connect(_finish.bind(callback), CONNECT_ONE_SHOT)
	show()
	set_process(true)

func holds_reset() -> bool:
	return _persist

func reset() -> void:
	if _persist:
		return
	_stop_timer()
	_set_inactive()

func _finish(callback: Callable) -> void:
	_persist = false
	_set_inactive()
	if callback.is_valid():
		callback.call()

func _set_inactive() -> void:
	_last_time_displayed = 0
	_label.text = "--:--"
	hide()
	set_process(false)

func _stop_timer() -> void:
	_timer.stop()
	for connection in _timer.timeout.get_connections():
		_timer.timeout.disconnect(connection.callable)

func is_ticking() -> bool:
	return _timer.time_left != 0

func _display_remaining_time() -> void:
	var time_left_int = _timer.time_left as int
	var time_left = _timer.time_left
	if time_left_int == 0:
		_label.text = "00:00"
		(_bar.material as ShaderMaterial).set_shader_parameter("progress", 0.0)
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
	(_bar.material as ShaderMaterial).set_shader_parameter("progress", time_left / _start_seconds)
	_last_time_displayed = time_left_int
