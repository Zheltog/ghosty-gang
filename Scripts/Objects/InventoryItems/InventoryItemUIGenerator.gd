class_name InventoryItemUIGenerator
extends Node

const INVENTORY_ITEM_UI = preload("res://Scenes/PointAndClick/InventoryUI/InventoryItemUI2D.tscn")

func generate(item : InventoryItemGenerator.INVENTORY_ITEM) -> InventoryItemUI:
	var item_ui = INVENTORY_ITEM_UI.instantiate() as InventoryItemUI
	item_ui.inventory_item_id = item
	setup_item_ui(item_ui, load(item_ui.generate_texture_path()))
	return item_ui

# SKIP GENERATION

static func setup_item_ui(item_ui : InventoryItemUI, image : Texture2D) -> void:
	if image == null:
		printerr("InventoryItemUIGenerator: no texture for item UI")
		return
	var sprite : Sprite2D = item_ui.get_node("Sprite2D")
	var area : Area2D = item_ui.get_node("Area2D")
	sprite.texture = image
	Area2DUtils.setup_collision_from_sprite(sprite, area, image)
