class_name EquippedItemUIGenerator
extends Object

const EQUIPPED_ITEM_UI = preload("res://Scenes/PointAndClick/InventoryUI/EquippedItemUI.tscn")

static func generate(item : InventoryItemGenerator.INVENTORY_ITEM) -> EquippedItemUI:
	var ui := EQUIPPED_ITEM_UI.instantiate() as EquippedItemUI
	match item:
		InventoryItemGenerator.INVENTORY_ITEM.SALT:
			_setup_salt(ui)
		InventoryItemGenerator.INVENTORY_ITEM.PEPPER:
			_setup_pepper(ui)
		InventoryItemGenerator.INVENTORY_ITEM.BOTTLE:
			_setup_bottle(ui)
		InventoryItemGenerator.INVENTORY_ITEM.PASSPORT:
			_setup_passport(ui)
		InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT:
			_setup_flashlight(ui)
	return ui

static func _setup_salt(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/salt.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_pepper(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/pepper.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_bottle(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/bottle.png"))
	frames.add_animation("drink")
	frames.add_frame("drink", preload("res://Assets/Sprites/EquipedInventoryItems/bottle_drink_0.png"))
	frames.add_frame("drink", preload("res://Assets/Sprites/EquipedInventoryItems/bottle_drink_1.png"))
	frames.add_frame("drink", preload("res://Assets/Sprites/EquipedInventoryItems/bottle_drink_2.png"))
	frames.add_frame("drink", preload("res://Assets/Sprites/EquipedInventoryItems/bottle_drink_3.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_passport(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/passport.png"))
	frames.add_animation("page1")
	frames.add_frame("page1", preload("res://Assets/Sprites/EquipedInventoryItems/passport_page1_0.png"))
	frames.add_animation("page2")
	frames.add_frame("page2", preload("res://Assets/Sprites/EquipedInventoryItems/passport_page2_0.png"))
	frames.add_animation("page3")
	frames.add_frame("page3", preload("res://Assets/Sprites/EquipedInventoryItems/passport_page3_0.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_flashlight(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/flashlight.png"))
	frames.add_animation("on")
	frames.add_frame("on", preload("res://Assets/Sprites/EquipedInventoryItems/flashlight_on_0.png"))
	ui.sprite_frames = frames
	ui.play("default")

# SKIP GENERATION
