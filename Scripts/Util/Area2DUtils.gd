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
