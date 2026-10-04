class_name DarknessEffect
extends Sprite2D

var _material: ShaderMaterial
var _inventory: Inventory

func _ready() -> void:
	_material = material as ShaderMaterial

func _process(_delta: float) -> void:
	if _material == null:
		return
	_material.set_shader_parameter("mouse_pos", get_global_mouse_position())
	_material.set_shader_parameter("light_on", _flashlight_lit())

func _flashlight_lit() -> bool:
	if not InventoryItemFlashlight.light_on:
		return false
	var inventory := _get_inventory()
	if inventory == null or inventory.equipped_item == null:
		return false
	return inventory.equipped_item.inventory_item_id == InventoryItemGenerator.INVENTORY_ITEM.FLASHLIGHT

func _get_inventory() -> Inventory:
	if is_instance_valid(_inventory):
		return _inventory
	var scene := get_tree().current_scene
	if scene == null:
		return null
	_inventory = NodeUtils.get_child_of_type(scene, Inventory) as Inventory
	return _inventory
