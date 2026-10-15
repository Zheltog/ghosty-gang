@tool
class_name DialogTreeDebug
extends Node2D

## Debug visualizer for Ink dialog trees.
## Hang on a node, assign `dialog_path` and `character`, press Generate.
## `# react_default` is shown on cards and is not added as a graph edge.

const Graph := preload("res://Scripts/Debug/DialogInkGraph.gd")

const TREE_NAME := "GeneratedTree"
const BLOCK := Vector2(400, 228)
const HUB_SIZE := Vector2(300, 48)
const RETURN_SIZE := Vector2(180, 40)
const TERMINAL_SIZE := Vector2(128, 48)
const COL_GAP := 96.0
const ROW_GAP := 40.0
const KNOT_GAP := 56.0
const SPRITE_BOX := Vector2(108, 108)

const COLOR_NEXT := Color(0.62, 0.66, 0.7)
const COLOR_CHOICE := Color(0.38, 0.72, 1.0)
const COLOR_DIVERT := Color(0.96, 0.78, 0.32)
const COLOR_TUNNEL := Color(0.72, 0.5, 1.0)
const COLOR_RETURN := Color(0.78, 0.6, 1.0)
const COLOR_REACT := Color(1.0, 0.48, 0.28)

@export_file("*.ink") var dialog_path: String = ""
@export var character: SceneCharacter
@export_file("*.tscn") var output_scene_path: String = "res://Scenes/Test/DialogTree/generated_dialog_tree.tscn"

@export_tool_button("Generate dialog tree")
var generate_action: Callable = generate

var _graph
var _camera: Camera2D
var _drag := false
var _drag_from := Vector2.ZERO
var _cam_from := Vector2.ZERO

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if has_node(TREE_NAME):
		_setup_runtime_camera()
		return
	generate()


func generate() -> void:
	if dialog_path.is_empty():
		printerr("DialogTreeDebug: assign dialog_path to an .ink file")
		return
	_graph = Graph.parse_file(dialog_path)
	if _graph.nodes.is_empty():
		printerr("DialogTreeDebug: no nodes parsed from ", dialog_path)
		return
	var actor := _resolve_character()
	if actor == null:
		printerr("DialogTreeDebug: assign a SceneCharacter on this node")
	var tree := _rebuild_tree()
	_build_cards(tree, actor)
	_own_generated(tree)
	_save_generated_scene(tree)
	print(
		"DialogTreeDebug: %s — %d replicas, %d nodes, %d edges"
		% [_graph.story_name if not _graph.story_name.is_empty() else dialog_path, _graph.replica_count(), _graph.nodes.size(), _graph.edges.size()]
	)
	if not Engine.is_editor_hint():
		_setup_runtime_camera()


func _resolve_character() -> SceneCharacter:
	if character != null:
		return character
	if not is_inside_tree():
		return null
	for node in find_children("*", "SceneCharacter", true, false):
		return node as SceneCharacter
	return null


func _rebuild_tree() -> Node2D:
	var existing := get_node_or_null(TREE_NAME)
	if existing != null:
		existing.free()
	var tree := Node2D.new()
	tree.name = TREE_NAME
	add_child(tree)
	return tree


func _build_cards(tree: Node2D, actor: SceneCharacter) -> void:
	var layout := _layout(_graph)
	var frames := _sprite_frames(actor)
	var actor_name := "" if actor == null else actor.character_name.strip_edges().to_lower()
	var rects: Dictionary = {}
	var blocks := Node2D.new()
	blocks.name = "Blocks"
	tree.add_child(blocks)
	var title := _make_title()
	blocks.add_child(title)
	for id in _graph.nodes:
		var node: Dictionary = _graph.nodes[id]
		var pos: Vector2 = layout.get(id, Vector2.ZERO)
		var size := _node_size(node)
		rects[id] = Rect2(pos, size)
		blocks.add_child(_make_card(node, pos, size, frames, actor_name, actor))
	var edges := _make_edges(rects)
	tree.add_child(edges)
	tree.move_child(edges, 0)


func _make_title() -> Label:
	var title := Label.new()
	title.name = "Title"
	title.position = Vector2(0, -72)
	var story := str(_graph.story_name)
	title.text = (story + "  ·  " if not story.is_empty() else "") + dialog_path
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.85, 0.88, 0.92))
	return title


func _make_card(
	node: Dictionary,
	pos: Vector2,
	size: Vector2,
	frames: SpriteFrames,
	actor_name: String,
	actor: SceneCharacter
) -> Control:
	var panel := Panel.new()
	panel.name = _safe_name(str(node.id))
	panel.position = pos
	panel.size = size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = _card_color(node)
	style.border_color = _card_border(node)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", style)
	match str(node.kind):
		Graph.KIND_REPLICA:
			_fill_replica(panel, node, frames, actor_name, actor, style)
		Graph.KIND_HUB:
			_fill_label(panel, str(node.text), 18, Color(0.9, 0.92, 0.95), true)
		Graph.KIND_RETURN:
			_fill_label(panel, str(node.text), 15, Color(0.86, 0.78, 1.0), true)
		Graph.KIND_END, Graph.KIND_DONE:
			_fill_label(panel, str(node.text), 20, Color(1, 0.85, 0.85), true)
		_:
			_fill_label(panel, str(node.text), 16, Color.WHITE, true)
	return panel


func _fill_replica(
	panel: Panel,
	node: Dictionary,
	frames: SpriteFrames,
	actor_name: String,
	actor: SceneCharacter,
	style: StyleBoxFlat
) -> void:
	var speaker := str(node.character).strip_edges()
	var emotion := str(node.animation).strip_edges()
	var texture := _portrait_texture(frames, speaker, actor_name, emotion, actor, node)
	if texture == null and _needs_portrait(speaker, actor_name, emotion):
		style.border_color = Color(0.95, 0.25, 0.25)
		style.set_border_width_all(3)
	if texture != null:
		var portrait := TextureRect.new()
		portrait.name = "Sprite"
		portrait.position = Vector2(10, 10)
		portrait.size = SPRITE_BOX
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.texture = texture
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(portrait)
	var text_left := 14.0 + (SPRITE_BOX.x + 8.0 if texture != null else 0.0)
	var who := Label.new()
	who.position = Vector2(text_left, 8)
	who.size = Vector2(panel.size.x - text_left - 12, 22)
	who.text = _speaker_caption(node)
	who.add_theme_font_size_override("font_size", 15)
	who.add_theme_color_override("font_color", Color(0.95, 0.9, 0.7))
	who.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(who)
	var knot := Label.new()
	knot.position = Vector2(text_left, 28)
	knot.size = Vector2(panel.size.x - text_left - 12, 18)
	knot.text = "%s  ·  %s:%s" % [node.knot, str(node.file).get_file(), str(node.line_no)]
	knot.add_theme_font_size_override("font_size", 11)
	knot.add_theme_color_override("font_color", Color(0.65, 0.68, 0.72))
	knot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(knot)
	var body := Label.new()
	body.position = Vector2(text_left, 50)
	body.size = Vector2(panel.size.x - text_left - 12, 120)
	body.text = str(node.text)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 15)
	body.add_theme_color_override("font_color", Color(0.92, 0.93, 0.95))
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(body)
	var meta := Label.new()
	meta.position = Vector2(10, panel.size.y - 36)
	meta.size = Vector2(panel.size.x - 20, 28)
	meta.text = _meta_line(node)
	meta.autowrap_mode = TextServer.AUTOWRAP_OFF
	meta.add_theme_font_size_override("font_size", 11)
	meta.add_theme_color_override("font_color", Color(0.7, 0.72, 0.78))
	meta.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(meta)


func _fill_label(panel: Panel, text: String, font_size: int, color: Color, centered: bool) -> void:
	var label := Label.new()
	label.position = Vector2(8, 8)
	label.size = panel.size - Vector2(16, 16)
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(label)


func _speaker_caption(node: Dictionary) -> String:
	if node.thought:
		return "thought" + ("" if str(node.character).is_empty() else " · %s" % node.character)
	if node.response:
		return "response" + ("" if str(node.character).is_empty() else " · %s" % node.character)
	if str(node.character).is_empty():
		return "line"
	return str(node.character)


func _meta_line(node: Dictionary) -> String:
	var bits: PackedStringArray = []
	if not str(node.animation).is_empty():
		bits.append("anim:%s" % node.animation)
	if not str(node.window).is_empty():
		bits.append("window:%s" % node.window)
	var defaults: Array = node.get("react_default", [])
	if not defaults.is_empty():
		var joined := ""
		for i in defaults.size():
			if i > 0:
				joined += ", "
			joined += str(defaults[i])
		bits.append("default " + joined)
	return "  ·  ".join(bits)


func _needs_portrait(speaker: String, actor_name: String, emotion: String) -> bool:
	if actor_name.is_empty() or emotion.is_empty():
		return false
	return speaker.strip_edges().to_lower() == actor_name


func _portrait_texture(
	frames: SpriteFrames,
	speaker: String,
	actor_name: String,
	emotion: String,
	actor: SceneCharacter,
	node: Dictionary
) -> Texture2D:
	if frames == null:
		return null
	var needle := speaker.strip_edges().to_lower()
	if needle.is_empty() or needle == DialogState.none_character:
		return null
	if not actor_name.is_empty() and needle != actor_name:
		return null
	var wanted := emotion
	if wanted.is_empty() and actor != null:
		wanted = actor.emotion
	if wanted.is_empty():
		return null
	var anim := _find_animation(frames, wanted)
	if anim.is_empty() or frames.get_frame_count(anim) <= 0:
		if _needs_portrait(speaker, actor_name, emotion):
			printerr(
				"DialogTreeDebug: no sprite '%s' on '%s' for '%s' (%s:%s)"
				% [wanted, actor_name, str(node.text).left(48), str(node.file).get_file(), str(node.line_no)]
			)
		return null
	return frames.get_frame_texture(anim, 0)


func _find_animation(frames: SpriteFrames, emotion: String) -> String:
	if frames.has_animation(emotion):
		return emotion
	var best := ""
	for anim in frames.get_animation_names():
		var name := String(anim)
		if name == emotion or name.ends_with("_" + emotion):
			if best.is_empty() or name.length() < best.length():
				best = name
	return best


func _sprite_frames(actor: SceneCharacter) -> SpriteFrames:
	if actor == null:
		return null
	if actor.sprite != null and actor.sprite.sprite_frames != null:
		return actor.sprite.sprite_frames
	var frames: Variant = actor.get("sprite_frames")
	if frames is SpriteFrames:
		return frames
	printerr("DialogTreeDebug: character '%s' has no SpriteFrames" % actor.character_name)
	return null


func _card_color(node: Dictionary) -> Color:
	match str(node.kind):
		Graph.KIND_HUB:
			return Color(0.16, 0.18, 0.24, 0.96)
		Graph.KIND_RETURN:
			return Color(0.18, 0.14, 0.26, 0.96)
		Graph.KIND_END:
			return Color(0.32, 0.12, 0.12, 0.96)
		Graph.KIND_DONE:
			return Color(0.22, 0.16, 0.12, 0.96)
		_:
			if node.thought:
				return Color(0.14, 0.18, 0.26, 0.96)
			if node.response:
				return Color(0.14, 0.22, 0.16, 0.96)
			return Color(0.13, 0.14, 0.17, 0.96)


func _card_border(node: Dictionary) -> Color:
	match str(node.kind):
		Graph.KIND_HUB:
			return Color(0.45, 0.5, 0.6)
		Graph.KIND_RETURN:
			return Color(0.6, 0.45, 0.9)
		Graph.KIND_END:
			return Color(0.9, 0.35, 0.35)
		Graph.KIND_DONE:
			return Color(0.85, 0.6, 0.3)
		_:
			return Color(0.35, 0.4, 0.48)


func _layout(graph) -> Dictionary:
	var layers := _knot_layers(graph)
	var pos: Dictionary = {}
	var col := 0
	for layer in layers:
		var x := col * (BLOCK.x + COL_GAP)
		var y := 0.0
		for knot in layer:
			for id in _nodes_in_knot(graph, str(knot)):
				var node: Dictionary = graph.nodes[id]
				var size := _node_size(node)
				pos[id] = Vector2(x, y)
				y += size.y + ROW_GAP
			y += KNOT_GAP
		col += 1
	var leftover_y := 0.0
	for id in graph.nodes:
		if pos.has(id):
			continue
		var node: Dictionary = graph.nodes[id]
		var size := _node_size(node)
		pos[id] = Vector2(col * (BLOCK.x + COL_GAP), leftover_y)
		leftover_y += size.y + ROW_GAP
	return pos


func _knot_layers(graph) -> Array:
	var start_knot := _start_knot(graph)
	var seen: Dictionary = {}
	var layers: Array = []
	var queue: Array = []
	if not start_knot.is_empty():
		queue.append(start_knot)
	while not queue.is_empty():
		var layer_size := queue.size()
		var layer: Array = []
		for _i in layer_size:
			var knot := str(queue.pop_front())
			if knot.is_empty() or seen.has(knot):
				continue
			seen[knot] = true
			layer.append(knot)
			for next_knot in _outgoing_knots(graph, knot):
				if not seen.has(next_knot):
					queue.append(next_knot)
		if not layer.is_empty():
			layers.append(layer)
	var rest: Array = []
	for path in graph.nodes:
		var node: Dictionary = graph.nodes[path]
		var knot := _node_knot(node)
		if knot.is_empty() or seen.has(knot):
			continue
		seen[knot] = true
		rest.append(knot)
	for knot in rest:
		layers.append([knot])
	if layers.is_empty():
		layers.append([""])
	return layers


func _start_knot(graph) -> String:
	if graph.start_id.is_empty() or not graph.nodes.has(graph.start_id):
		return ""
	return _node_knot(graph.nodes[graph.start_id])


func _outgoing_knots(graph, knot: String) -> Array:
	var out: Array = []
	for edge in graph.edges:
		if not graph.nodes.has(edge.from) or not graph.nodes.has(edge.to):
			continue
		if _node_knot(graph.nodes[edge.from]) != knot:
			continue
		var dest := _node_knot(graph.nodes[edge.to])
		if dest.is_empty() or dest == knot or out.has(dest):
			continue
		out.append(dest)
	return out


func _nodes_in_knot(graph, knot: String) -> Array:
	var hubs: Array = []
	var replicas: Array = []
	var returns: Array = []
	var rest: Array = []
	for id in graph.nodes:
		var node: Dictionary = graph.nodes[id]
		if _node_knot(node) != knot:
			continue
		match str(node.kind):
			Graph.KIND_HUB:
				hubs.append(id)
			Graph.KIND_REPLICA:
				replicas.append(id)
			Graph.KIND_RETURN:
				returns.append(id)
			_:
				rest.append(id)
	replicas.sort()
	returns.sort()
	return hubs + replicas + returns + rest


func _node_knot(node: Dictionary) -> String:
	var knot := str(node.get("knot", ""))
	if not knot.is_empty():
		return knot
	if str(node.get("kind", "")) == Graph.KIND_HUB:
		return str(node.get("text", ""))
	return ""


func _node_size(node: Dictionary) -> Vector2:
	match str(node.kind):
		Graph.KIND_HUB:
			return HUB_SIZE
		Graph.KIND_RETURN:
			return RETURN_SIZE
		Graph.KIND_END, Graph.KIND_DONE:
			return TERMINAL_SIZE
		_:
			return BLOCK


func _make_edges(rects: Dictionary) -> Node2D:
	var holder := Node2D.new()
	holder.name = "Edges"
	holder.z_index = -1
	var i := 0
	for edge in _graph.edges:
		if not rects.has(edge.from) or not rects.has(edge.to):
			continue
		var from_rect: Rect2 = rects[edge.from]
		var to_rect: Rect2 = rects[edge.to]
		var kind := str(edge.kind)
		var color := _edge_color(kind)
		var a := _edge_start(from_rect, to_rect)
		var b := _edge_end(from_rect, to_rect)
		var offset := clampf(a.distance_to(b) * 0.35, 48.0, 160.0)
		var c1 := a + _edge_out(from_rect, to_rect) * offset
		var c2 := b - _edge_in(from_rect, to_rect) * offset
		var pts := PackedVector2Array()
		var steps := 24
		for s in steps + 1:
			pts.append(_cubic(a, c1, c2, b, float(s) / float(steps)))
		var line := Line2D.new()
		line.name = "E%d" % i
		line.width = 2.0 if kind == Graph.EDGE_RETURN else 2.6
		line.default_color = color
		line.antialiased = true
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		line.points = pts
		holder.add_child(line)
		var arrow := Polygon2D.new()
		arrow.name = "A%d" % i
		arrow.color = color
		var dir := (pts[pts.size() - 1] - pts[pts.size() - 2]).normalized()
		if dir != Vector2.ZERO:
			var tip: Vector2 = pts[pts.size() - 1]
			arrow.polygon = PackedVector2Array([
				tip,
				tip - dir.rotated(0.45) * 12.0,
				tip - dir.rotated(-0.45) * 12.0,
			])
		holder.add_child(arrow)
		var label := str(edge.get("label", ""))
		if not label.is_empty() and kind != Graph.EDGE_NEXT:
			var caption := Label.new()
			caption.name = "L%d" % i
			caption.text = label.left(42)
			caption.position = _cubic(a, c1, c2, b, 0.5) + Vector2(8, -12)
			caption.add_theme_font_size_override("font_size", 12)
			caption.add_theme_color_override("font_color", color.lightened(0.25))
			caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
			holder.add_child(caption)
		i += 1
	return holder


func _edge_color(kind: String) -> Color:
	match kind:
		Graph.EDGE_CHOICE:
			return COLOR_CHOICE
		Graph.EDGE_DIVERT:
			return COLOR_DIVERT
		Graph.EDGE_TUNNEL:
			return COLOR_TUNNEL
		Graph.EDGE_RETURN:
			return COLOR_RETURN
		Graph.EDGE_REACT:
			return COLOR_REACT
		_:
			return COLOR_NEXT


func _edge_start(from_rect: Rect2, to_rect: Rect2) -> Vector2:
	if absf(from_rect.position.x - to_rect.position.x) < 8.0:
		return Vector2(from_rect.get_center().x, from_rect.end.y)
	if to_rect.position.x >= from_rect.position.x:
		return Vector2(from_rect.end.x, from_rect.get_center().y)
	return Vector2(from_rect.position.x, from_rect.get_center().y)


func _edge_end(from_rect: Rect2, to_rect: Rect2) -> Vector2:
	if absf(from_rect.position.x - to_rect.position.x) < 8.0:
		return Vector2(to_rect.get_center().x, to_rect.position.y)
	if to_rect.position.x >= from_rect.position.x:
		return Vector2(to_rect.position.x, to_rect.get_center().y)
	return Vector2(to_rect.end.x, to_rect.get_center().y)


func _edge_out(from_rect: Rect2, to_rect: Rect2) -> Vector2:
	if absf(from_rect.position.x - to_rect.position.x) < 8.0:
		return Vector2.DOWN
	return Vector2.RIGHT if to_rect.position.x >= from_rect.position.x else Vector2.LEFT


func _edge_in(from_rect: Rect2, to_rect: Rect2) -> Vector2:
	if absf(from_rect.position.x - to_rect.position.x) < 8.0:
		return Vector2.DOWN
	return Vector2.RIGHT if to_rect.position.x >= from_rect.position.x else Vector2.LEFT


func _cubic(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var u := 1.0 - t
	return u * u * u * p0 + 3.0 * u * u * t * p1 + 3.0 * u * t * t * p2 + t * t * t * p3


func _own_generated(tree: Node) -> void:
	if not Engine.is_editor_hint() or not is_inside_tree():
		return
	var root := get_tree().edited_scene_root
	if root == null:
		return
	tree.owner = root
	_set_owner_recursive(tree, root)


func _set_owner_recursive(node: Node, owner: Node) -> void:
	for child in node.get_children():
		child.owner = owner
		_set_owner_recursive(child, owner)


func _save_generated_scene(tree: Node) -> void:
	if output_scene_path.is_empty():
		return
	var packed_root := tree.duplicate()
	packed_root.name = "DialogTree"
	_set_owner_recursive(packed_root, packed_root)
	var packed := PackedScene.new()
	var err := packed.pack(packed_root)
	packed_root.free()
	if err != OK:
		printerr("DialogTreeDebug: failed to pack scene (", err, ")")
		return
	err = ResourceSaver.save(packed, output_scene_path)
	if err != OK:
		printerr("DialogTreeDebug: failed to save ", output_scene_path, " (", err, ")")
		return
	print("DialogTreeDebug: wrote ", output_scene_path)
	if Engine.is_editor_hint() and Engine.has_singleton("EditorInterface"):
		Engine.get_singleton("EditorInterface").get_resource_filesystem().scan()


func _setup_runtime_camera() -> void:
	if _camera != null:
		return
	_camera = get_node_or_null("Camera2D") as Camera2D
	if _camera == null:
		_camera = Camera2D.new()
		_camera.name = "Camera2D"
		add_child(_camera)
	_camera.enabled = true


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint() or _camera == null:
		return
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_WHEEL_UP and mouse.pressed:
			_camera.zoom *= 1.1
			get_viewport().set_input_as_handled()
		elif mouse.button_index == MOUSE_BUTTON_WHEEL_DOWN and mouse.pressed:
			_camera.zoom *= 0.9
			get_viewport().set_input_as_handled()
		elif mouse.button_index == MOUSE_BUTTON_MIDDLE:
			_drag = mouse.pressed
			_drag_from = mouse.position
			_cam_from = _camera.position
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and _drag:
		var motion := event as InputEventMouseMotion
		_camera.position = _cam_from - (motion.position - _drag_from) / _camera.zoom
		get_viewport().set_input_as_handled()


func _safe_name(id: String) -> String:
	return id.replace(":", "_").replace(".", "_")
