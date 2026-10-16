#!/usr/bin/env python3
"""Bake SceneItemUI collision polygons into textures for OutlineShader.

Run from the repo root:
  python3 Scripts/Tools/bake_scene_item_outlines.py
The textures are written once and assigned in the scene files.
"""

import math
import os
import re
import struct
import sys
import zlib

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUTLINE_DIR = "res://Assets/Sprites/SceneItems/Outlines"
PADDING = 64
SCENE_ITEM_SCRIPTS = {
	"SceneItemUI.gd",
	"SceneUIDoor.gd",
	"CustomBookshelfSceneItemUI.gd",
	"CustomSceneItemUIBase.gd",
	"CustomSceneItemUIInDarkness.gd",
	"CustomBookSceneItemUI.gd",
}
SKIP_SCRIPTS = {"CharacterSceneItemUI.gd"}

EXT_RE = re.compile(
	r'\[ext_resource type="([^"]+)"(?: uid="[^"]+")? path="([^"]+)" id="([^"]+)"\]'
)
NODE_RE = re.compile(r'^\[node ([^\]]+)\]$')
ATTR_RE = re.compile(r'(\w+)="([^"]*)"')
VECTOR_RE = re.compile(r"Vector2\(\s*([-\d.eE]+)\s*,\s*([-\d.eE]+)\s*\)")
POLYGON_RE = re.compile(r"PackedVector2Array\(([^)]*)\)")


def res_to_fs(path):
	return os.path.join(ROOT, path.removeprefix("res://"))


def fs_to_res(path):
	rel = os.path.relpath(path, ROOT).replace(os.sep, "/")
	return "res://" + rel


class NodeRec:
	def __init__(self, name, parent, type_name, instance):
		self.name = name
		self.parent = parent
		self.type_name = type_name
		self.instance = instance
		self.props = {}

	def path(self):
		if self.parent is None:
			return ""
		if self.parent in ("", "."):
			return self.name
		return self.parent + "/" + self.name


def parse_scene(path):
	text = open(path, encoding="utf-8").read()
	resources = {}
	for match in EXT_RE.finditer(text):
		resources[match.group(3)] = match.group(2)
	nodes = []
	lines = text.splitlines()
	index = 0
	while index < len(lines):
		header = NODE_RE.match(lines[index])
		if not header:
			index += 1
			continue
		attrs = dict(ATTR_RE.findall(header.group(1)))
		node = NodeRec(attrs.get("name", ""), attrs.get("parent"), attrs.get("type"), attrs.get("instance"))
		index += 1
		while index < len(lines) and not lines[index].startswith("["):
			line = lines[index]
			if " = " in line:
				key, value = line.split(" = ", 1)
				node.props[key] = value
			index += 1
		nodes.append(node)
	return resources, nodes


def resolve_resource(scene_path, token, resources):
	if token == "null":
		return None
	match = re.fullmatch(r'ExtResource\("([^"]+)"\)', token)
	if not match:
		return None
	return resources.get(match.group(1))


def vector2(value):
	match = VECTOR_RE.search(value)
	if not match:
		return (0.0, 0.0)
	return (float(match.group(1)), float(match.group(2)))


def polygon(value):
	match = POLYGON_RE.search(value)
	if not match or not match.group(1).strip():
		return []
	nums = [float(part) for part in match.group(1).split(",") if part.strip()]
	return list(zip(nums[0::2], nums[1::2]))


def node_transform(node):
	position = vector2(node.props["position"]) if "position" in node.props else (0.0, 0.0)
	scale = vector2(node.props["scale"]) if "scale" in node.props else (1.0, 1.0)
	rotation = float(node.props["rotation"]) if "rotation" in node.props else 0.0
	cos_r = math.cos(rotation)
	sin_r = math.sin(rotation)
	column0 = (cos_r * scale[0], sin_r * scale[0])
	column1 = (-sin_r * scale[1], cos_r * scale[1])
	return (column0, column1, position)


def apply_transform(transform, point):
	column0, column1, origin = transform
	return (
		column0[0] * point[0] + column1[0] * point[1] + origin[0],
		column0[1] * point[0] + column1[1] * point[1] + origin[1],
	)


def multiply_transform(parent, child):
	column0 = apply_transform((parent[0], parent[1], (0.0, 0.0)), child[0])
	column1 = apply_transform((parent[0], parent[1], (0.0, 0.0)), child[1])
	origin = apply_transform(parent, child[2])
	return (column0, column1, origin)


SCENE_CACHE = {}


def load_scene(path):
	if path not in SCENE_CACHE:
		fs_path = res_to_fs(path)
		if not os.path.isfile(fs_path):
			SCENE_CACHE[path] = ({}, [])
		else:
			SCENE_CACHE[path] = parse_scene(fs_path)
	return SCENE_CACHE[path]


def scene_root(path):
	_, nodes = load_scene(path)
	return nodes[0] if nodes else None


def effective_script(scene_path, node):
	if "script" in node.props:
		resources, _ = load_scene(scene_path)
		return resolve_resource(scene_path, node.props["script"], resources)
	if node.instance:
		resources, _ = load_scene(scene_path)
		base_path = resolve_resource(scene_path, node.instance, resources)
		if not base_path:
			return None
		base_root = scene_root(base_path)
		if base_root is None:
			return None
		return effective_script(base_path, base_root)
	return None


def effective_texture(scene_path, node):
	if "texture" in node.props:
		resources, _ = load_scene(scene_path)
		return resolve_resource(scene_path, node.props["texture"], resources)
	if node.instance:
		resources, _ = load_scene(scene_path)
		base_path = resolve_resource(scene_path, node.instance, resources)
		if not base_path:
			return None
		base_root = scene_root(base_path)
		if base_root is None:
			return None
		return effective_texture(base_path, base_root)
	return None


def is_scene_item(scene_path, node):
	script = effective_script(scene_path, node)
	if not script:
		return False
	file_name = script.rsplit("/", 1)[-1]
	if file_name in SKIP_SCRIPTS:
		return False
	return file_name in SCENE_ITEM_SCRIPTS


def is_sprite(scene_path, node):
	if node.type_name == "Sprite2D":
		return True
	if not node.instance:
		return False
	resources, _ = load_scene(scene_path)
	base_path = resolve_resource(scene_path, node.instance, resources)
	base_root = scene_root(base_path) if base_path else None
	return base_root is not None and is_sprite(base_path, base_root)


def find_nodes(scene_path):
	resources, nodes = load_scene(scene_path)
	by_path = {}
	for node in nodes:
		by_path[node.path()] = node
	return resources, nodes, by_path


def descendants(nodes, root_path):
	prefix = root_path + "/"
	return [node for node in nodes if node.path().startswith(prefix)]


def collect_polygons(nodes, by_path, sprite_path, area_name):
	area_path = area_name if sprite_path == "" else f"{sprite_path}/{area_name}"
	if area_path not in by_path:
		return []
	polygons = []
	for node in descendants(nodes, area_path):
		if node.type_name != "CollisionPolygon2D" or "polygon" not in node.props:
			continue
		local_points = polygon(node.props["polygon"])
		if len(local_points) < 3:
			continue
		points = []
		for point in local_points:
			transform = ((1.0, 0.0), (0.0, 1.0), (0.0, 0.0))
			current = node
			while current is not None and current.path() != sprite_path:
				transform = multiply_transform(node_transform(current), transform)
				if current.parent in (None, ".", ""):
					current = by_path.get("")
				else:
					current = by_path.get(current.parent)
			points.append(apply_transform(transform, point))
		polygons.append(points)
	return polygons


def bounds_of(polygons):
	min_x = min(point[0] for poly in polygons for point in poly)
	min_y = min(point[1] for poly in polygons for point in poly)
	max_x = max(point[0] for poly in polygons for point in poly)
	max_y = max(point[1] for poly in polygons for point in poly)
	width = max(1, int(math.ceil(max_x - min_x)) + PADDING * 2)
	height = max(1, int(math.ceil(max_y - min_y)) + PADDING * 2)
	offset = (min_x - PADDING + width * 0.5, min_y - PADDING + height * 0.5)
	return (min_x, min_y), (width, height), offset


def rasterize(polygons, origin, size):
	width, height = size
	buffer = bytearray(width * height * 4)
	origin_x, origin_y = origin
	for polygon_points in polygons:
		image_points = [
			(point[0] - origin_x + PADDING, point[1] - origin_y + PADDING)
			for point in polygon_points
		]
		min_y = min(point[1] for point in image_points)
		max_y = max(point[1] for point in image_points)
		y0 = max(0, int(math.floor(min_y)))
		y1 = min(height - 1, int(math.ceil(max_y)))
		count = len(image_points)
		for y in range(y0, y1 + 1):
			scan_y = y + 0.5
			crossings = []
			for index in range(count):
				start = image_points[index]
				end = image_points[(index + 1) % count]
				if abs(start[1] - end[1]) < 1e-8:
					continue
				if (start[1] <= scan_y < end[1]) or (end[1] <= scan_y < start[1]):
					weight = (scan_y - start[1]) / (end[1] - start[1])
					crossings.append(start[0] + (end[0] - start[0]) * weight)
			crossings.sort()
			pair = 0
			row = y * width * 4
			while pair + 1 < len(crossings):
				x0 = max(0, int(math.ceil(crossings[pair])))
				x1 = min(width - 1, int(math.floor(crossings[pair + 1])))
				for x in range(x0, x1 + 1):
					pixel = row + x * 4
					buffer[pixel:pixel + 4] = b"\xff\xff\xff\xff"
				pair += 2
	return buffer


def write_png(path, size, buffer):
	width, height = size
	os.makedirs(os.path.dirname(path), exist_ok=True)

	def chunk(tag, data):
		return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

	raw = bytearray()
	stride = width * 4
	for y in range(height):
		raw.append(0)
		raw.extend(buffer[y * stride:(y + 1) * stride])
	png = b"\x89PNG\r\n\x1a\n"
	png += chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0))
	png += chunk(b"IDAT", zlib.compress(bytes(raw), 9))
	png += chunk(b"IEND", b"")
	with open(path, "wb") as handle:
		handle.write(png)


def file_stub(scene_path, node_path):
	scene_name = os.path.splitext(os.path.basename(scene_path))[0]
	return scene_name + "_" + node_path.replace("/", "_")


def collect_edits():
	edits_by_scene = {}
	for dir_path, _, files in os.walk(os.path.join(ROOT, "Scenes")):
		for file_name in files:
			if not file_name.endswith(".tscn"):
				continue
			fs_path = os.path.join(dir_path, file_name)
			scene_path = fs_to_res(fs_path)
			_, nodes, by_path = find_nodes(scene_path)
			edits = []
			for node in nodes:
				if not is_sprite(scene_path, node) or not is_scene_item(scene_path, node):
					continue
				texture = effective_texture(scene_path, node)
				if texture and "/Outlines/" not in texture:
					continue
				sprite_path = node.path()
				main_polys = collect_polygons(nodes, by_path, sprite_path, "Area2D")
				if not main_polys:
					continue
				moved_polys = collect_polygons(nodes, by_path, sprite_path, "Area2DAfterMove")
				bounds_polys = main_polys + moved_polys
				origin, size, offset = bounds_of(bounds_polys)
				stub = file_stub(scene_path, sprite_path)
				edits.append({
					"node_name": node.name,
					"parent": node.parent,
					"texture_path": f"{OUTLINE_DIR}/{stub}.png",
					"moved_path": f"{OUTLINE_DIR}/{stub}_moved.png" if moved_polys else None,
					"ext_id": f"outline_{stub}",
					"offset": offset,
					"main": rasterize(main_polys, origin, size),
					"moved": rasterize(moved_polys, origin, size) if moved_polys else None,
					"size": size,
					"scene_node": sprite_path,
				})
			if edits:
				edits_by_scene[fs_path] = edits
	return edits_by_scene


def patch_scene(fs_path, edits):
	text = open(fs_path, encoding="utf-8").read()
	newline = "\n"
	for edit in edits:
		if f'path="{edit["texture_path"]}"' not in text:
			ext_line = f'[ext_resource type="Texture2D" path="{edit["texture_path"]}" id="{edit["ext_id"]}"]'
			lines = text.splitlines()
			insert_at = 1
			for index, line in enumerate(lines):
				if line.startswith("[ext_resource"):
					insert_at = index + 1
			lines.insert(insert_at, ext_line)
			text = newline.join(lines) + (newline if text.endswith(newline) else "")
		text = patch_node(text, edit)
	with open(fs_path, "w", encoding="utf-8", newline="\n") as handle:
		handle.write(text)


def patch_node(text, edit):
	lines = text.splitlines()
	header = None
	name_token = f'name="{edit["node_name"]}"'
	parent_token = f'parent="{edit["parent"]}"'
	for index, line in enumerate(lines):
		if line.startswith("[node ") and name_token in line and parent_token in line:
			header = index
			break
	if header is None:
		raise SystemExit(f"node not found: {edit['node_name']} parent {edit['parent']}")
	body_end = len(lines)
	for index in range(header + 1, len(lines)):
		if lines[index].startswith("["):
			body_end = index
			break
	kept = []
	for line in lines[header + 1:body_end]:
		if line.startswith(("texture =", "offset =", "texture_filter =", "instance_shader_parameters/fill_visible", "centered =")):
			continue
		kept.append(line)
	offset_x, offset_y = edit["offset"]
	block = [
		lines[header],
		f'texture = ExtResource("{edit["ext_id"]}")',
		f"offset = Vector2({offset_x:.4f}, {offset_y:.4f})",
		"texture_filter = 1",
		"instance_shader_parameters/fill_visible = false",
		*kept,
	]
	rebuilt = lines[:header] + block + lines[body_end:]
	suffix = "\n" if text.endswith("\n") else ""
	return "\n".join(rebuilt) + suffix


def main():
	edits_by_scene = collect_edits()
	total = 0
	for fs_path, edits in edits_by_scene.items():
		for edit in edits:
			png_path = res_to_fs(edit["texture_path"])
			write_png(png_path, edit["size"], edit["main"])
			if edit["moved"] is not None:
				write_png(res_to_fs(edit["moved_path"]), edit["size"], edit["moved"])
			print(f"baked {fs_to_res(fs_path)} :: {edit['scene_node']}  {edit['size'][0]}x{edit['size'][1]}  offset {edit['offset']}")
			total += 1
		patch_scene(fs_path, edits)
	print(f"baked {total} sprites")


if __name__ == "__main__":
	sys.exit(main())
