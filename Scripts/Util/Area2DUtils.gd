class_name Area2DUtils
extends Object

static func get_at_mouse(from : CanvasItem) -> Array[Area2D]:
	if _is_gui_blocking(from.get_viewport()):
		return []
	return _query_at_mouse(from)


static func _is_gui_blocking(viewport : Viewport) -> bool:
	var hovered := viewport.gui_get_hovered_control()
	if hovered == null:
		return false
	return hovered.mouse_filter == Control.MOUSE_FILTER_STOP


static func _query_at_mouse(from : CanvasItem) -> Array[Area2D]:
	var areas : Array[Area2D] = []
	var params := PhysicsPointQueryParameters2D.new()
	params.position = from.get_global_mouse_position()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	var results := from.get_world_2d().direct_space_state.intersect_point(params)
	for result in results:
		var area := result.collider as Area2D
		if area == null or areas.has(area):
			continue
		var insert_at := areas.size()
		for i in areas.size():
			if _is_in_front_of(area, areas[i]):
				insert_at = i
				break
		areas.insert(insert_at, area)
	return areas

static func _is_in_front_of(a : CanvasItem, b : CanvasItem) -> bool:
	var a_sort := _sort_canvas_item(a)
	var b_sort := _sort_canvas_item(b)
	if a_sort.z_index != b_sort.z_index:
		return a_sort.z_index > b_sort.z_index
	return a_sort.is_greater_than(b_sort)

static func _sort_canvas_item(area : CanvasItem) -> CanvasItem:
	var parent := area.get_parent()
	if parent is CanvasItem:
		return parent
	return area

## Builds CollisionPolygon2D children on [param area] from the opaque pixels of [param image]
## (or [param sprite].texture). If [param area] is under [param sprite], polygons stay in
## local sprite space (scale is inherited); otherwise polygons are multiplied by sprite.scale.
static func setup_collision_from_sprite(sprite: Sprite2D, area: Area2D, image: Texture2D = null) -> void:
	if image == null:
		image = sprite.texture
	if image == null:
		printerr("Area2DUtils: no texture for collision setup")
		return

	var bitmap := BitMap.new()
	var source_image := image.get_image()
	if source_image == null:
		printerr("Area2DUtils: could not read image pixels")
		return
	source_image = source_image.duplicate()
	if source_image.is_compressed():
		source_image.decompress()
	bitmap.create_from_image_alpha(source_image)

	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	# Sprite2D centers the texture at origin, but opaque_to_polygons returns
	# coordinates in image space (top-left = 0,0). Shift to match the sprite.
	var offset := -Vector2(bitmap.get_size()) / 2.0
	if not sprite.centered:
		offset = Vector2.ZERO
	offset += sprite.offset

	var apply_sprite_scale := not sprite.is_ancestor_of(area)

	for child in area.get_children():
		if child is CollisionPolygon2D:
			child.free()

	for polygon in polygons:
		var shifted := PackedVector2Array()
		for p in polygon:
			var point: Vector2 = p + offset
			if apply_sprite_scale:
				point *= sprite.scale
			shifted.append(point)
		var collider := CollisionPolygon2D.new()
		collider.polygon = shifted
		area.add_child(collider)
