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

	var bitmap := BitMap.new()
	var source_image := image.get_image()
	if source_image == null:
		printerr("InventoryItemUIGenerator: could not read image pixels")
		return
	source_image = source_image.duplicate()
	if source_image.is_compressed():
		source_image.decompress()
	bitmap.create_from_image_alpha(source_image)

	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	# Sprite2D centers the texture at origin, but opaque_to_polygons returns
	# coordinates in image space (top-left = 0,0). Shift and scale to match the sprite.
	var offset := -Vector2(bitmap.get_size()) / 2.0
	if not sprite.centered:
		offset = Vector2.ZERO
	offset += sprite.offset

	for child in area.get_children():
		if child is CollisionPolygon2D:
			child.free()

	for polygon in polygons:
		var shifted := PackedVector2Array()
		for p in polygon:
			shifted.append((p + offset) * sprite.scale)
		var collider := CollisionPolygon2D.new()
		collider.polygon = shifted
		area.add_child(collider)
