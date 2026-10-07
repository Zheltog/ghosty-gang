extends Node2D

const GUN := InventoryItemGenerator.INVENTORY_ITEM.GUN
const PHOTO := InventoryItemGenerator.INVENTORY_ITEM.PHOTO

@onready var _dialog: DialogController = $DialogController
@onready var _buttons: VBoxContainer = $Hud/Buttons
@onready var _log: Label = $Hud/Log

func _ready() -> void:
	_add_event("1  Достать пистолет", KEY_1, func(): return _dialog.try_inventory_choice(Inventory.EVENT.EQUIP, GUN))
	_add_event("2  Убрать пистолет", KEY_2, func(): return _dialog.try_inventory_choice(Inventory.EVENT.UNEQUIP, GUN))
	_add_event("3  Выстрелить", KEY_3, func(): return _dialog.try_action("shoot"))
	_add_event("4  Показать фото", KEY_4, func(): return _dialog.try_inventory_choice(Inventory.EVENT.EQUIP, PHOTO))
	_add_button("5  Начать заново", KEY_5, func():
		_dialog.start_story()
		_log.text = "Диалог начат заново."
	)

func _add_event(label: String, key: Key, send: Callable) -> void:
	_add_button(label, key, func():
		var fired: bool = send.call()
		_log.text = "%s: %s" % [label.substr(3), "реакция сработала" if fired else "на этой строке реакции нет"]
	)

func _add_button(label: String, key: Key, on_pressed: Callable) -> void:
	var button := Button.new()
	button.text = label
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 28)
	var key_event := InputEventKey.new()
	key_event.keycode = key
	var shortcut := Shortcut.new()
	shortcut.events = [key_event]
	button.shortcut = shortcut
	button.pressed.connect(on_pressed)
	_buttons.add_child(button)
