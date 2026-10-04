class_name EquippedItemUIGenerator
extends Object

const EQUIPPED_ITEM_UI = preload("res://Scenes/PointAndClick/InventoryUI/EquippedItemUI.tscn")

static func generate(item : InventoryItemGenerator.INVENTORY_ITEM) -> EquippedItemUI:
	var ui := EQUIPPED_ITEM_UI.instantiate() as EquippedItemUI
	match item:
		InventoryItemGenerator.INVENTORY_ITEM.CIGARETTES:
			_setup_cigarettes(ui)
		InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT:
			_setup_flashlight(ui)
		InventoryItemGenerator.INVENTORY_ITEM.GUN:
			_setup_gun(ui)
		InventoryItemGenerator.INVENTORY_ITEM.KEY_BOOKSHELF:
			_setup_key_bookshelf(ui)
		InventoryItemGenerator.INVENTORY_ITEM.PASSPORT:
			_setup_passport(ui)
		InventoryItemGenerator.INVENTORY_ITEM.PHOTO:
			_setup_photo(ui)
		InventoryItemGenerator.INVENTORY_ITEM.TEA:
			_setup_tea(ui)
		InventoryItemGenerator.INVENTORY_ITEM.GLASS_EYE:
			_setup_glass_eye(ui)
		InventoryItemGenerator.INVENTORY_ITEM.RAG:
			_setup_rag(ui)
	return ui

static func _setup_cigarettes(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/cigarettes.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_flashlight(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/flashlight.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_gun(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/gun.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_key_bookshelf(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/key_bookshelf.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_passport(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/passport.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_photo(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_glass_eye(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/glass_eye.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_rag(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/rag.png"))
	ui.sprite_frames = frames
	ui.play("default")
static func _setup_tea(ui: EquippedItemUI) -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.add_frame("default", preload("res://Assets/Sprites/EquipedInventoryItems/tea.png"))
	frames.add_animation("empty")
	frames.add_frame("empty", preload("res://Assets/Sprites/EquipedInventoryItems/tea_empty_0.png"))
	ui.sprite_frames = frames
	ui.play("default")

# SKIP GENERATION
