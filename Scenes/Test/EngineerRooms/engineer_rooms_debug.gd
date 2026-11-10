extends HouseSceneBase

const START_ROOM := "preroom"
const PANEL_WIDTH := 480.0
const CYCLE_SECONDS := 1.0

const CHARACTER_MATERIAL := preload("res://Assets/Material/character_pixelization.tres")
const TEX_STAND_NORMAL := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/standing_normal.png")
const TEX_STAND_BACK := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/standing_back.png")
const TEX_STAND_SCARED := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/standing_scared.png")
const TEX_STAND_SUSPICIOUS := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/standing_sus.png")
const TEX_STAND_CHAIR := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/standing_chair.png")
const TEX_CLOSE := preload("res://Assets/Sprites/Characters/Engineer/Dron/close_scary.png")
const TEX_SIT_NORMAL := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/sitting_normal.png")
const TEX_SIT_REACH := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/sitting_taking_body.png")
const TEX_SIT_SCARED := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/sitting_scared.png")
const TEX_SIT_SUSPICIOUS := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/sitting_sus.png")
const TEX_LAY_DEAD := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/lay_dead.png")
const TEX_HAND := preload("res://Assets/Sprites/Characters/Engineer/Dron/raw/sitting_taking_arm.png")

# Флаги, без которых сцена не пускает дальше: шкаф не двигается, книга Морозова не открывает скважину.
const PROGRESS_FLAGS: Array[String] = ["seen_photo", "coat_key_taken", "closet_open"]

const EMOTIONS: Array[String] = [
	"stand_normal",
	"stand_back",
	"stand_scared",
	"stand_suspicious",
	"stand_tea",
	"stand_chair",
	"stand_close1",
	"sit_normal",
	"sit_reach",
	"sit_scared",
	"sit_suspicious",
	"lay_dead",
]
const EMOTION_LABELS: Array[String] = [
	"Стоит",
	"Спиной",
	"Испуг",
	"Подозрение",
	"С чаем",
	"Со стулом",
	"Крупный план",
	"Сидит",
	"Тянется",
	"Сидит, испуг",
	"Сидит, подозрение",
	"Лежит",
]
const ROOM_LABELS := {
	"preroom": "Прихожая",
	"living_room": "Гостиная",
	"living_room_2": "Гостиная 2",
	"living_room_to_exit": "К выходу",
	"under_bed": "Под кроватью",
	"kitchen": "Кухня",
	"kitchen_couch": "Диван",
	"bathroom": "Ванная",
	"bookshelf": "Шкаф",
	"storage": "Кладовка",
	"exit_from_storage": "Выход из кладовки",
}
const ROOM_ORDER: Array[String] = [
	"preroom",
	"living_room",
	"living_room_2",
	"living_room_to_exit",
	"under_bed",
	"kitchen",
	"kitchen_couch",
	"bathroom",
	"bookshelf",
	"storage",
	"exit_from_storage",
]

@onready var _engineer: SceneCharacterEngineer = $Characters/Engineer
@onready var _hand: AnimatedSprite2D = $Characters/Engineer/Hand

var _show_box: CheckBox
var _cycle_box: CheckBox
var _emotion_button: OptionButton
var _room_buttons: Dictionary = {}
var _emotion_index := 0
var _updating_ui := false
var _cycle_timer: Timer


func _ready() -> void:
	_open_progress_gates()
	_build_sprites()
	super._ready()
	_finish_open_shelf()
	_give_items()
	_build_ui()
	load_room(START_ROOM)


func _load_room_scenes() -> void:
	super._load_room_scenes()
	var rooms := get_node_or_null(ROOMS_NODE_NAME)
	if rooms == null:
		return
	for child in rooms.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false


func load_room(room_name: String) -> void:
	super.load_room(room_name)
	if current_room != room_name:
		return
	_sync_engineer()
	_highlight_room(room_name)


func _open_progress_gates() -> void:
	StateManager.clear_state()
	StateManager.set_state(CustomBookshelfSceneItemUI.STATE_BOOK_REMOVED, true)
	StateManager.set_state(CustomBookshelfSceneItemUI.STATE_KEY_TURNED, true)
	StateManager.set_state(CustomBookshelfSceneItemUI.STATE_OPEN, true)
	InkVariableStore.clear()
	for variable_name in PROGRESS_FLAGS:
		InkVariableStore.set_value(variable_name, true)


func _finish_open_shelf() -> void:
	var shelf := find_child("Shelfs", true, false) as CustomBookshelfSceneItemUI
	if shelf == null:
		printerr("EngineerRoomsDebug: shelf is missing")
		return
	var book := shelf.get_node_or_null("Books5") as CanvasItem
	if book:
		book.hide()
	shelf._remove_keyhole()
	shelf._disable_books()
	shelf._apply_open(true)


func _give_items() -> void:
	var inventory := get_node_or_null("Inventory") as Inventory
	if inventory == null or inventory.inventory_holder == null:
		printerr("EngineerRoomsDebug: inventory is missing")
		return
	var items: Array[InventoryItemGenerator.INVENTORY_ITEM] = [
		InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT,
		InventoryItemGenerator.INVENTORY_ITEM.KEY_BOOKSHELF,
	]
	for item_id in items:
		if not inventory.has_item(item_id):
			inventory.inventory_holder.add_item(item_id)


func _build_sprites() -> void:
	_engineer.material = CHARACTER_MATERIAL
	_engineer.sprite_frames = _sprite_frames([
		["stand_normal", TEX_STAND_NORMAL],
		["stand_back", TEX_STAND_BACK],
		["stand_scared", TEX_STAND_SCARED],
		["stand_suspicious", TEX_STAND_SUSPICIOUS],
		["stand_tea", TEX_STAND_NORMAL],
		["stand_chair", TEX_STAND_CHAIR],
		["stand_close1", _close_texture()],
		["sit_normal", TEX_SIT_NORMAL],
		["sit_reach", TEX_SIT_REACH],
		["sit_scared", TEX_SIT_SCARED],
		["sit_suspicious", TEX_SIT_SUSPICIOUS],
		["lay_dead", TEX_LAY_DEAD],
	])
	_engineer.animation = "stand_normal"
	_hand.material = CHARACTER_MATERIAL
	var hand_frames := SpriteFrames.new()
	hand_frames.add_frame("default", TEX_HAND)
	_hand.sprite_frames = hand_frames
	_hand.animation = "default"


func _close_texture() -> Texture2D:
	var atlas := AtlasTexture.new()
	atlas.atlas = TEX_CLOSE
	atlas.region = Rect2(0, 0, 4064, 3048)
	return atlas


func _sprite_frames(animations: Array) -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for animation in animations:
		var anim_name := str(animation[0])
		frames.add_animation(anim_name)
		frames.set_animation_loop(anim_name, true)
		frames.set_animation_speed(anim_name, 5.0)
		frames.add_frame(anim_name, animation[1])
	return frames


func _build_ui() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)

	var panel := PanelContainer.new()
	panel.position = Vector2(1920.0 - 16.0 - PANEL_WIDTH, 16.0)
	panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.05, 0.82)
	style.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", style)
	layer.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var title := Label.new()
	title.text = "Комнаты инженера"
	_set_font_size(title, 22)
	box.add_child(title)

	_show_box = CheckBox.new()
	_show_box.text = "Показывать инженера"
	_show_box.button_pressed = true
	_set_font_size(_show_box, 18)
	_show_box.toggled.connect(func(_on: bool) -> void: _sync_engineer())
	box.add_child(_show_box)

	_cycle_box = CheckBox.new()
	_cycle_box.text = "Цикл эмоций"
	_set_font_size(_cycle_box, 18)
	_cycle_box.toggled.connect(_on_cycle_toggled)
	box.add_child(_cycle_box)

	_emotion_button = OptionButton.new()
	_set_font_size(_emotion_button, 18)
	for label in EMOTION_LABELS:
		_emotion_button.add_item(label)
	_emotion_button.select(0)
	_emotion_button.item_selected.connect(_on_emotion_selected)
	box.add_child(_emotion_button)

	var rooms_title := Label.new()
	rooms_title.text = "Переход"
	_set_font_size(rooms_title, 18)
	box.add_child(rooms_title)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	box.add_child(grid)

	for room_name in _ordered_room_names():
		var button := Button.new()
		button.text = str(ROOM_LABELS.get(room_name, room_name))
		button.custom_minimum_size = Vector2(0, 36)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_set_font_size(button, 16)
		button.pressed.connect(_on_room_pressed.bind(room_name))
		grid.add_child(button)
		_room_buttons[room_name] = button

	_cycle_timer = Timer.new()
	_cycle_timer.wait_time = CYCLE_SECONDS
	_cycle_timer.timeout.connect(_cycle_emotion)
	add_child(_cycle_timer)


func _ordered_room_names() -> Array[String]:
	var names: Array[String] = []
	var rooms := get_node_or_null(ROOMS_NODE_NAME)
	if rooms == null:
		return names
	for child in rooms.get_children():
		if child is RoomBase:
			names.append((child as RoomBase).room_name)
	names.sort_custom(func(a: String, b: String) -> bool: return _room_index(a) < _room_index(b))
	return names


func _room_index(room_name: String) -> int:
	var index := ROOM_ORDER.find(room_name)
	return index if index >= 0 else ROOM_ORDER.size()


func _on_room_pressed(room_name: String) -> void:
	load_room(room_name)


func _on_emotion_selected(index: int) -> void:
	if _updating_ui:
		return
	_emotion_index = index
	if _cycle_box.button_pressed:
		_cycle_box.button_pressed = false
	_apply_emotion()


func _on_cycle_toggled(enabled: bool) -> void:
	_emotion_button.disabled = enabled
	if enabled:
		_cycle_timer.start()
	else:
		_cycle_timer.stop()


func _cycle_emotion() -> void:
	if EMOTIONS.is_empty():
		return
	_emotion_index = (_emotion_index + 1) % EMOTIONS.size()
	_updating_ui = true
	_emotion_button.select(_emotion_index)
	_updating_ui = false
	_apply_emotion()


func _apply_emotion() -> void:
	if not _engineer_should_show():
		return
	_engineer.set_emotion(EMOTIONS[_emotion_index])


func _sync_engineer() -> void:
	if _engineer == null:
		return
	if not _engineer_should_show():
		_engineer.location = ""
		_engineer.visible = false
		return
	_engineer.set_emotion(EMOTIONS[_emotion_index])
	_engineer.set_location(current_room)


func _engineer_should_show() -> bool:
	return _show_box != null and _show_box.button_pressed and _room_has_character_positions(current_room)


func _room_has_character_positions(room_name: String) -> bool:
	var rooms := get_node_or_null(ROOMS_NODE_NAME)
	if rooms == null:
		return false
	for child in rooms.get_children():
		if child is RoomBase and (child as RoomBase).room_name == room_name:
			return child.get_node_or_null(SceneCharacter.EMOTION_POINTS) != null
	return false


func _highlight_room(room_name: String) -> void:
	for name in _room_buttons:
		var button := _room_buttons[name] as Button
		if button == null:
			continue
		button.disabled = name == room_name


func _set_font_size(control: Control, size: int) -> void:
	control.add_theme_font_size_override("font_size", size)
