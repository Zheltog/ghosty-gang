class_name DialogInkGraph
extends RefCounted

## Static graph of an Ink dialog: spoken lines, choice/divert/react edges.
## `# react_default` is tracked on each replica but never turned into an edge.

const KIND_REPLICA := "replica"
const KIND_HUB := "hub"
const KIND_RETURN := "return"
const KIND_END := "end"
const KIND_DONE := "done"

const EDGE_NEXT := "next"
const EDGE_CHOICE := "choice"
const EDGE_DIVERT := "divert"
const EDGE_TUNNEL := "tunnel"
const EDGE_RETURN := "return"
const EDGE_REACT := "react"

var nodes: Dictionary = {}
var edges: Array = []
var start_id: String = ""
var source_path: String = ""
var story_name: String = ""

var _lines: Array = []
var _i: int = 0
var _next_id: int = 0
var _state: DialogState
var _defaults: Array[String] = []
var _sections: Dictionary = {}
var _section_order: Array[String] = []
var _divert_re: RegEx
var _returns_by_knot: Dictionary = {}
var _tunnel_sites: Array = []
var _knot_links: Dictionary = {}

static func parse_file(path: String):
	var script := load("res://Scripts/Debug/DialogInkGraph.gd") as GDScript
	var graph = script.new()
	graph._parse(path)
	return graph


func _init() -> void:
	_divert_re = RegEx.new()
	_divert_re.compile("^->\\s*(->|END|DONE|[A-Za-z_][\\w.]*)")


func _parse(path: String) -> void:
	source_path = path
	_state = DialogState.new()
	if not FileAccess.file_exists(path):
		printerr("DialogInkGraph: file not found: ", path)
		return
	_parse_file_tree(path, {}, true)
	_emit_graph()
	_wire_tunnel_returns()
	_ensure_terminals()
	if start_id.is_empty() and not _section_order.is_empty():
		start_id = _hub(_section_order[0])


func _parse_file_tree(path: String, seen: Dictionary, is_root: bool) -> void:
	var resolved := path.simplify_path()
	if resolved.is_empty():
		return
	if seen.has(resolved):
		printerr("DialogInkGraph: cyclic INCLUDE ", resolved)
		return
	if not FileAccess.file_exists(resolved):
		printerr("DialogInkGraph: INCLUDE not found: ", resolved)
		return
	seen[resolved] = true
	var includes: Array = []
	var lines := _read_file_lines(resolved, includes)
	var saved := _lines
	_lines = lines
	_split_sections(is_root)
	_lines = saved
	for inc in includes:
		_parse_file_tree(str(inc), seen, false)


func _read_file_lines(resolved: String, includes: Array) -> Array:
	var file := FileAccess.open(resolved, FileAccess.READ)
	if file == null:
		printerr("DialogInkGraph: failed to open ", resolved)
		return []
	var out: Array = []
	var line_no := 0
	for raw in file.get_as_text().split("\n"):
		line_no += 1
		var cleaned := _strip_comment(str(raw)).rstrip(" \t\r")
		if cleaned.strip_edges().is_empty():
			continue
		var upper := cleaned.strip_edges().to_upper()
		if upper.begins_with("INCLUDE "):
			includes.append(_resolve_include(resolved, cleaned.strip_edges().substr(8).strip_edges()))
			continue
		if (
			upper.begins_with("EXTERNAL ")
			or upper.begins_with("VAR ")
			or upper.begins_with("CONST ")
			or upper.begins_with("LIST ")
		):
			continue
		out.append({
			"file": resolved,
			"line_no": line_no,
			"indent": _measure_indent(cleaned),
			"content": cleaned.strip_edges(),
		})
	return out


func _resolve_include(from_file: String, include_path: String) -> String:
	if include_path.begins_with("res://") or include_path.begins_with("/"):
		return include_path
	return from_file.get_base_dir().path_join(include_path).simplify_path()


func _split_sections(use_start: bool) -> void:
	var knot := ""
	var stitch := ""
	var bucket: Array = []
	var preamble: Array = []
	for line in _lines:
		var content := str(line.content)
		if _is_knot_header(content):
			_flush_section(knot, stitch, bucket)
			bucket = []
			knot = _header_name(content)
			stitch = ""
			continue
		if _is_stitch_header(content):
			_flush_section(knot, stitch, bucket)
			bucket = []
			stitch = _header_name(content)
			continue
		if knot.is_empty() and stitch.is_empty():
			preamble.append(line)
		else:
			bucket.append(line)
	_flush_section(knot, stitch, bucket)
	if use_start:
		_ingest_preamble(preamble)


func _flush_section(knot: String, stitch: String, bucket: Array) -> void:
	if knot.is_empty() and stitch.is_empty():
		return
	var path := knot if stitch.is_empty() else ("%s.%s" % [knot, stitch])
	if path.is_empty():
		return
	_sections[path] = _parse_line_array(bucket)
	if not _section_order.has(path):
		_section_order.append(path)


func _ingest_preamble(preamble: Array) -> void:
	var global_tags: Array[String] = []
	for line in preamble:
		var content := str(line.content)
		if content.begins_with("#"):
			global_tags.append_array(_parse_tag_source(content))
			continue
		var split := _split_content(content)
		if split.diverts.is_empty():
			continue
		var first: Dictionary = split.diverts[0]
		var target := str(first.get("target", ""))
		if not target.is_empty() and target != "->" and target != "END" and target != "DONE":
			start_id = _hub(target)
	if not global_tags.is_empty():
		_state.apply(global_tags)
		var names := InkTagParser.values_for_key(global_tags, "story")
		if not names.is_empty():
			story_name = names[0]


func _parse_stmt_list(parent_indent: int) -> Array:
	var stmts: Array = []
	while _i < _lines.size():
		var line: Dictionary = _lines[_i]
		if parent_indent >= 0 and int(line.indent) <= parent_indent:
			break
		var content := str(line.content)
		if _is_knot_header(content) or _is_stitch_header(content):
			break
		if content == "}" or content.is_empty():
			_i += 1
			continue
		if _is_choice(content):
			stmts.append(_parse_choice_group(int(line.indent)))
			continue
		if _starts_condition(content):
			stmts.append(_parse_condition())
			continue
		stmts.append(_parse_simple(line))
		_i += 1
	return stmts


func _parse_choice_group(indent: int) -> Dictionary:
	var choices: Array = []
	while _i < _lines.size():
		var line: Dictionary = _lines[_i]
		if int(line.indent) != indent or not _is_choice(str(line.content)):
			break
		choices.append(_parse_one_choice())
	var gather: Variant = null
	if _i < _lines.size():
		var line: Dictionary = _lines[_i]
		if int(line.indent) == indent and _is_gather(str(line.content)):
			gather = _parse_simple(line)
			_i += 1
	return {"kind": "choices", "choices": choices, "gather": gather}


func _parse_one_choice() -> Dictionary:
	var line: Dictionary = _lines[_i]
	_i += 1
	var header := _parse_choice_header(str(line.content))
	header["kind"] = "choice"
	header["body"] = _parse_stmt_list(int(line.indent))
	header["file"] = line.file
	header["line_no"] = line.line_no
	return header


func _parse_condition() -> Dictionary:
	var collected: Array = []
	var depth := 0
	while _i < _lines.size():
		var line: Dictionary = _lines[_i]
		collected.append(line)
		depth += _brace_delta(str(line.content))
		_i += 1
		if depth <= 0:
			break
	if depth > 0:
		printerr("DialogInkGraph: unclosed '{' in ", source_path)
	return _build_condition(collected)


func _build_condition(collected: Array) -> Dictionary:
	if collected.is_empty():
		return {"kind": "condition", "expr": "", "then_body": [], "else_body": [], "arms": []}
	var inner: Array = []
	for i in collected.size():
		inner.append(collected[i].duplicate())
	var first: Dictionary = inner[0]
	first.content = str(first.content).strip_edges()
	if str(first.content).begins_with("{"):
		first.content = str(first.content).substr(1).strip_edges()
	var last: Dictionary = inner[inner.size() - 1]
	var last_text := str(last.content).strip_edges()
	if last_text.ends_with("}"):
		last_text = last_text.substr(0, last_text.length() - 1).rstrip(" \t\r")
		last.content = last_text
		if last_text.is_empty() and inner.size() > 1:
			inner.pop_back()
	if inner.is_empty():
		return {"kind": "condition", "expr": "", "then_body": [], "else_body": [], "arms": []}
	var head := str(inner[0].content).strip_edges()
	if head.begins_with("-"):
		return {"kind": "switch", "arms": _parse_switch_arms(inner)}
	var colon := _condition_colon(head)
	var expr := head if colon < 0 else head.left(colon).strip_edges()
	var inline := "" if colon < 0 else head.substr(colon + 1).strip_edges()
	var then_lines: Array = []
	var else_lines: Array = []
	if not inline.is_empty():
		then_lines.append({
			"file": first.file,
			"line_no": first.line_no,
			"indent": int(first.indent) + 4,
			"content": inline,
		})
	var dest := then_lines
	for i in range(1, inner.size()):
		var ln: Dictionary = inner[i]
		var text := str(ln.content).strip_edges()
		if text.begins_with("- else"):
			dest = else_lines
			var else_colon := text.find(":")
			var after := "" if else_colon < 0 else text.substr(else_colon + 1).strip_edges()
			if not after.is_empty() and after != "}":
				dest.append({
					"file": ln.file,
					"line_no": ln.line_no,
					"indent": int(ln.indent) + 4,
					"content": after,
				})
			continue
		dest.append(ln)
	return {
		"kind": "condition",
		"expr": expr,
		"then_body": _parse_line_array(then_lines),
		"else_body": _parse_line_array(else_lines),
		"arms": [],
	}


func _parse_switch_arms(inner: Array) -> Array:
	var arms: Array = []
	var expr := ""
	var bucket: Array = []
	var file := ""
	var line_no := 0
	for ln in inner:
		var text := str(ln.content).strip_edges()
		if text.begins_with("-") and text.contains(":"):
			if not expr.is_empty() or not bucket.is_empty():
				arms.append({"expr": expr, "body": _parse_line_array(bucket)})
			var cut := text.find(":")
			expr = text.substr(1, cut - 1).strip_edges()
			var after := text.substr(cut + 1).strip_edges()
			bucket = []
			file = str(ln.file)
			line_no = int(ln.line_no)
			if not after.is_empty() and after != "}":
				bucket.append({
					"file": file,
					"line_no": line_no,
					"indent": int(ln.indent) + 4,
					"content": after,
				})
			continue
		bucket.append(ln)
	if not expr.is_empty() or not bucket.is_empty():
		arms.append({"expr": expr, "body": _parse_line_array(bucket)})
	return arms


func _parse_line_array(lines: Array) -> Array:
	var filtered: Array = []
	for ln in lines:
		if str(ln.get("content", "")).strip_edges().is_empty():
			continue
		filtered.append(ln)
	if filtered.is_empty():
		return []
	var saved_lines := _lines
	var saved_i := _i
	_lines = filtered
	_i = 0
	var stmts := _parse_stmt_list(-1)
	_lines = saved_lines
	_i = saved_i
	return stmts


func _parse_simple(line: Dictionary) -> Dictionary:
	var split := _split_content(str(line.content))
	var kind := "text"
	if str(split.text).begins_with("~"):
		kind = "logic"
	elif str(split.text).is_empty() and not split.diverts.is_empty():
		kind = "divert"
	elif str(split.text).is_empty():
		kind = "tags"
	return {
		"kind": kind,
		"text": split.text,
		"tags": split.tags,
		"diverts": split.diverts,
		"file": line.file,
		"line_no": line.line_no,
	}


func _parse_choice_header(content: String) -> Dictionary:
	var raw := content.strip_edges()
	var sticky := raw.begins_with("+")
	var rest := raw.substr(1).strip_edges()
	var cond := ""
	if rest.begins_with("{"):
		var end := rest.find("}")
		if end >= 0:
			cond = rest.substr(1, end - 1).strip_edges()
			rest = rest.substr(end + 1).strip_edges()
	var label := rest
	var after := ""
	if rest.begins_with("["):
		var end := rest.find("]")
		if end >= 0:
			label = rest.substr(1, end - 1).strip_edges()
			after = rest.substr(end + 1).strip_edges()
		else:
			label = rest.substr(1).strip_edges()
	else:
		var divert_at := rest.find("->")
		if divert_at >= 0:
			label = rest.left(divert_at).strip_edges()
			after = rest.substr(divert_at).strip_edges()
		else:
			label = rest
	if not cond.is_empty():
		label = "{%s} %s" % [cond, label]
	return {
		"sticky": sticky,
		"label": label,
		"diverts": _parse_divert_chain(after) if after.begins_with("->") else [],
	}


func _emit_graph() -> void:
	_node(_end_id(), KIND_END, "END", "")
	_node(_done_id(), KIND_DONE, "DONE", "")
	for path in _section_order:
		_hub(path)
	var base := _snap()
	for path in _section_order:
		_restore(base)
		var incoming: Array = [_hub(path)]
		incoming = _emit_stmts(_sections[path], incoming, path, EDGE_NEXT, "")
		for leftover in incoming:
			if str(leftover).begins_with("h:"):
				continue
			_connect([leftover], _done_id(), EDGE_NEXT, "")


func _emit_stmts(stmts: Array, incoming: Array, knot: String, first_kind: String, first_label: String) -> Array:
	var kind := first_kind
	var label := first_label
	for stmt in stmts:
		incoming = _emit_stmt(stmt, incoming, knot, kind, label)
		kind = EDGE_NEXT
		label = ""
	return incoming


func _emit_stmt(stmt: Dictionary, incoming: Array, knot: String, kind: String, label: String) -> Array:
	match str(stmt.get("kind", "")):
		"choices":
			return _emit_choices(stmt, incoming, knot)
		"condition":
			return _emit_condition(stmt, incoming, knot)
		"switch":
			return _emit_switch(stmt, incoming, knot)
		"logic":
			_apply_tags(stmt.get("tags", []))
			return incoming
		"tags":
			_apply_tags(stmt.get("tags", []))
			return incoming
		"divert":
			_apply_tags(stmt.get("tags", []))
			return _emit_diverts(incoming, stmt.get("diverts", []), knot, kind, label)
		"text":
			return _emit_text(stmt, incoming, knot, kind, label)
		_:
			return incoming


func _emit_text(stmt: Dictionary, incoming: Array, knot: String, kind: String, label: String) -> Array:
	var tags: Array = stmt.get("tags", [])
	_apply_tags(tags)
	var replica_id := _add_replica(stmt, knot)
	_connect(incoming, replica_id, kind, label)
	_emit_react_edges(replica_id, tags, knot)
	var diverts: Array = stmt.get("diverts", [])
	if not diverts.is_empty():
		return _emit_diverts([replica_id], diverts, knot, EDGE_DIVERT, "")
	return [replica_id]


func _emit_choices(stmt: Dictionary, incoming: Array, knot: String) -> Array:
	var outs: Array = []
	var snap := _snap()
	for choice in stmt.get("choices", []):
		_restore(snap)
		var choice_label := str(choice.get("label", ""))
		var body: Array = choice.get("body", [])
		var header_diverts: Array = choice.get("diverts", [])
		var out: Array = incoming.duplicate()
		if not body.is_empty():
			out = _emit_stmts(body, incoming.duplicate(), knot, EDGE_CHOICE, choice_label)
		elif not header_diverts.is_empty():
			out = _emit_diverts(incoming.duplicate(), header_diverts, knot, EDGE_CHOICE, choice_label)
		else:
			_connect(incoming, _done_id(), EDGE_CHOICE, choice_label)
			out = []
		if not header_diverts.is_empty() and not body.is_empty():
			out = _emit_diverts(out, header_diverts, knot, EDGE_DIVERT, "")
		outs.append_array(out)
	_restore(snap)
	var gather: Variant = stmt.get("gather", null)
	if gather is Dictionary:
		return _emit_stmt(gather, outs, knot, EDGE_NEXT, "")
	return outs


func _emit_condition(stmt: Dictionary, incoming: Array, knot: String) -> Array:
	var snap := _snap()
	var then_out := _emit_stmts(stmt.get("then_body", []), incoming.duplicate(), knot, EDGE_NEXT, "")
	_restore(snap)
	var else_body: Array = stmt.get("else_body", [])
	var else_out: Array = incoming.duplicate()
	if not else_body.is_empty():
		else_out = _emit_stmts(else_body, incoming.duplicate(), knot, EDGE_NEXT, "")
	_restore(snap)
	var merged: Array = []
	merged.append_array(then_out)
	merged.append_array(else_out)
	return _unique_ids(merged)


func _emit_switch(stmt: Dictionary, incoming: Array, knot: String) -> Array:
	var snap := _snap()
	var merged: Array = []
	var arms: Array = stmt.get("arms", [])
	if arms.is_empty():
		return incoming
	for arm in arms:
		_restore(snap)
		merged.append_array(_emit_stmts(arm.get("body", []), incoming.duplicate(), knot, EDGE_NEXT, ""))
	_restore(snap)
	return _unique_ids(merged)


func _emit_diverts(incoming: Array, diverts: Array, knot: String, kind: String, label: String) -> Array:
	var current := incoming.duplicate()
	var edge_kind := kind
	var edge_label := label
	for divert in diverts:
		var target := str(divert.get("target", ""))
		var tunnel := bool(divert.get("tunnel", false))
		if target == "->":
			_mark_returns(knot, current)
			current = []
			continue
		if target == "END":
			_connect(current, _end_id(), edge_kind if edge_kind != EDGE_NEXT else EDGE_DIVERT, edge_label if not edge_label.is_empty() else "END")
			current = []
			continue
		if target == "DONE":
			_connect(current, _done_id(), edge_kind if edge_kind != EDGE_NEXT else EDGE_DIVERT, edge_label if not edge_label.is_empty() else "DONE")
			current = []
			continue
		var dest := _resolve_path(knot, target)
		_link_knots(knot, dest)
		var dest_id := _hub(dest)
		var use_kind := EDGE_TUNNEL if tunnel else (edge_kind if edge_kind != EDGE_NEXT else EDGE_DIVERT)
		var use_label := edge_label if not edge_label.is_empty() else dest
		_connect(current, dest_id, use_kind, use_label)
		if tunnel:
			var ret_id := _add_return_hub(knot, dest)
			_tunnel_sites.append({"target": dest, "return_id": ret_id})
			current = [ret_id]
		else:
			current = []
		edge_kind = EDGE_DIVERT
		edge_label = ""
	return current


func _emit_react_edges(from_id: String, tags: Array, knot: String) -> void:
	for value in InkTagParser.values_for_key(tags, "react"):
		var path := _reaction_path(str(value))
		if path.is_empty():
			continue
		var dest := _resolve_path(knot, path)
		_link_knots(knot, dest)
		_connect([from_id], _hub(dest), EDGE_REACT, _reaction_label(str(value)))


func _add_replica(stmt: Dictionary, knot: String) -> String:
	var id := "r%d" % _next_id
	_next_id += 1
	_node(id, KIND_REPLICA, str(stmt.get("text", "")), knot)
	var node: Dictionary = nodes[id]
	node.tags = stmt.get("tags", []).duplicate()
	node.file = stmt.get("file", "")
	node.line_no = stmt.get("line_no", 0)
	node.character = _state.character_name
	node.animation = _state.animation_name if _state.has_animation else ""
	node.thought = _state.thought
	node.response = _state.response
	node.window = _state.window_name
	node.react_default = _defaults.duplicate()
	return id


func _add_return_hub(caller_knot: String, target: String) -> String:
	var id := "ret%d" % _next_id
	_next_id += 1
	_node(id, KIND_RETURN, "↩ %s" % target, caller_knot)
	return id


func _hub(path: String) -> String:
	var id := "h:%s" % path
	if not nodes.has(id):
		_node(id, KIND_HUB, path, path)
	return id


func _end_id() -> String:
	return "end"


func _done_id() -> String:
	return "done"


func _node(id: String, kind: String, text: String, knot: String) -> void:
	if nodes.has(id):
		return
	nodes[id] = {
		"id": id,
		"kind": kind,
		"text": text,
		"knot": knot,
		"tags": [],
		"file": "",
		"line_no": 0,
		"character": "",
		"animation": "",
		"thought": false,
		"response": false,
		"window": "",
		"react_default": [],
	}


func _connect(from_ids: Array, to_id: String, kind: String, label: String) -> void:
	for from in from_ids:
		var from_id := str(from)
		if from_id.is_empty() or to_id.is_empty() or from_id == to_id:
			continue
		if _has_edge(from_id, to_id, kind, label):
			continue
		edges.append({
			"from": from_id,
			"to": to_id,
			"kind": kind,
			"label": label,
		})


func _has_edge(from_id: String, to_id: String, kind: String, label: String) -> bool:
	for edge in edges:
		if edge.from == from_id and edge.to == to_id and edge.kind == kind and edge.label == label:
			return true
	return false


func _mark_returns(knot: String, incoming: Array) -> void:
	if not _returns_by_knot.has(knot):
		_returns_by_knot[knot] = []
	var bucket: Array = _returns_by_knot[knot]
	for from in incoming:
		var from_id := str(from)
		if from_id.is_empty() or bucket.has(from_id):
			continue
		bucket.append(from_id)


func _link_knots(from_knot: String, to_knot: String) -> void:
	if from_knot.is_empty() or to_knot.is_empty() or from_knot == to_knot:
		return
	if not _knot_links.has(from_knot):
		_knot_links[from_knot] = []
	var bucket: Array = _knot_links[from_knot]
	if not bucket.has(to_knot):
		bucket.append(to_knot)


func _wire_tunnel_returns() -> void:
	for site in _tunnel_sites:
		var target := str(site.get("target", ""))
		var return_id := str(site.get("return_id", ""))
		if target.is_empty() or return_id.is_empty():
			continue
		for knot in _reachable_knots(target):
			for src in _returns_by_knot.get(knot, []):
				_connect([src], return_id, EDGE_RETURN, "->->")


func _reachable_knots(start: String) -> Array:
	var out: Array = []
	var queue: Array = [start]
	while not queue.is_empty():
		var knot := str(queue.pop_front())
		if knot.is_empty() or out.has(knot) or knot == "END" or knot == "DONE":
			continue
		out.append(knot)
		for next_knot in _knot_links.get(knot, []):
			queue.append(next_knot)
	return out


func _ensure_terminals() -> void:
	var used_end := false
	var used_done := false
	for edge in edges:
		if edge.to == _end_id():
			used_end = true
		if edge.to == _done_id():
			used_done = true
	if not used_end:
		nodes.erase(_end_id())
	if not used_done:
		nodes.erase(_done_id())


func _apply_tags(tags: Variant) -> void:
	var list: Array[String] = []
	for tag in tags:
		list.append(str(tag))
	if _has_tag_key(list, "react_default"):
		_defaults = InkTagParser.values_for_key(list, "react_default")
	if not list.is_empty():
		_state.apply(list)


func _snap() -> Dictionary:
	return {
		"state": _state.snapshot(),
		"defaults": _defaults.duplicate(),
	}


func _restore(snap: Dictionary) -> void:
	_state.copy_from(snap.state)
	_defaults.clear()
	for value in snap.defaults:
		_defaults.append(str(value))


func _resolve_path(current: String, name: String) -> String:
	var needle := name.strip_edges()
	if needle.is_empty() or needle == "END" or needle == "DONE" or needle == "->":
		return needle
	if _sections.has(needle):
		return needle
	var knot := current.split(".")[0]
	var local := "%s.%s" % [knot, needle]
	if _sections.has(local):
		return local
	return needle


func _split_content(content: String) -> Dictionary:
	var stripped := content.strip_edges()
	var text := stripped
	var tag_src := ""
	if stripped.begins_with("#"):
		text = ""
		tag_src = stripped
	else:
		var tag_at := stripped.find(" #")
		if tag_at != -1:
			text = stripped.left(tag_at).strip_edges()
			tag_src = stripped.substr(tag_at).strip_edges()
	while text.begins_with("%"):
		text = text.substr(1).strip_edges()
	var diverts: Array = []
	var divert_at := text.find("->")
	if divert_at != -1:
		diverts = _parse_divert_chain(text.substr(divert_at).strip_edges())
		text = text.left(divert_at).strip_edges()
	return {
		"text": text,
		"tags": _parse_tag_source(tag_src),
		"diverts": diverts,
	}


func _parse_divert_chain(source: String) -> Array:
	var diverts: Array = []
	var rest := source.strip_edges()
	while rest.begins_with("->"):
		var matched := _divert_re.search(rest)
		if matched == null:
			if not diverts.is_empty():
				diverts[diverts.size() - 1]["tunnel"] = true
			break
		var token := matched.get_string(1)
		rest = rest.substr(matched.get_end()).strip_edges()
		if token == "->":
			diverts.append({"target": "->", "tunnel": false})
			continue
		if not diverts.is_empty() and str(diverts[diverts.size() - 1].get("target", "")) != "->":
			diverts[diverts.size() - 1]["tunnel"] = true
		diverts.append({"target": token, "tunnel": false})
	return diverts


func _parse_tag_source(src: String) -> Array[String]:
	var tags: Array[String] = []
	if src.is_empty():
		return tags
	for part in src.split("#"):
		var tag := str(part).strip_edges()
		if tag.is_empty():
			continue
		tags.append(tag)
	return tags


func _reaction_path(value: String) -> String:
	var parts := value.strip_edges().to_lower().split(":")
	if parts.size() < 3:
		return ""
	return str(parts[2]).strip_edges()


func _reaction_label(value: String) -> String:
	var parts := value.strip_edges().to_lower().split(":")
	if parts.size() < 2:
		return value
	var label := "%s:%s" % [parts[0], parts[1]]
	if parts.size() >= 4 and str(parts[3]).strip_edges() == "back":
		label += ":back"
	return label


func _has_tag_key(tags: Array, key: String) -> bool:
	var needle := key.strip_edges().to_lower()
	var prefix := needle + ":"
	for tag in tags:
		var normalized := str(tag).strip_edges().to_lower()
		if normalized == needle or normalized.begins_with(prefix):
			return true
	return false


func _unique_ids(ids: Array) -> Array:
	var out: Array = []
	for id in ids:
		var text := str(id)
		if text.is_empty() or out.has(text):
			continue
		out.append(text)
	return out


func _is_knot_header(content: String) -> bool:
	return content.strip_edges().begins_with("===")


func _is_stitch_header(content: String) -> bool:
	var text := content.strip_edges()
	return text.begins_with("=") and not text.begins_with("==")


func _header_name(content: String) -> String:
	return content.strip_edges().replace("=", "").strip_edges()


func _is_choice(content: String) -> bool:
	var text := content.strip_edges()
	if text.is_empty() or (text[0] != "*" and text[0] != "+"):
		return false
	if text.length() == 1:
		return true
	var next := text[1]
	return next == " " or next == "\t" or next == "{" or next == "["


func _is_gather(content: String) -> bool:
	var text := content.strip_edges()
	return text.begins_with("- ") and not text.begins_with("- else")


func _starts_condition(content: String) -> bool:
	return content.strip_edges().begins_with("{")


func _brace_delta(text: String) -> int:
	var delta := 0
	for i in text.length():
		var ch := text[i]
		if ch == "{":
			delta += 1
		elif ch == "}":
			delta -= 1
	return delta


func _condition_colon(text: String) -> int:
	var depth := 0
	for i in text.length():
		var ch := text[i]
		if ch == "{":
			depth += 1
		elif ch == "}":
			depth -= 1
		elif ch == ":" and depth == 0:
			return i
	return -1


func _measure_indent(line: String) -> int:
	var n := 0
	for i in line.length():
		var ch := line[i]
		if ch == "\t":
			n += 4
		elif ch == " ":
			n += 1
		else:
			break
	return n


func _strip_comment(line: String) -> String:
	var idx := line.find("//")
	if idx == -1:
		return line
	return line.left(idx)


func replica_count() -> int:
	var n := 0
	for id in nodes:
		if nodes[id].kind == KIND_REPLICA:
			n += 1
	return n
