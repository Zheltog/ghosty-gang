class_name SaveManager

static func save_file_path() -> String:
	var root := OS.get_executable_path().get_base_dir()
	if OS.has_feature("editor"):
		root = ProjectSettings.globalize_path("res://")
	return root.path_join("save.v1.data")

static var _cached_save: SaveData = null
static var day: int = 0
static var items: Array[String] = []

static func save(data: SaveData) -> void:
	var dictionary = data.to_dictionary()
	StorageManager.write_json_to(save_file_path(), dictionary)
	_cached_save = null

static func load_from_save() -> SaveData:
	if _cached_save != null:
		return _cached_save
	var dictionary = StorageManager.read_json_from(save_file_path())
	_cached_save = SaveData.new(dictionary)
	return _cached_save

static func has_checkpoint() -> bool:
	return load_from_save().day > 0

static func reset_runtime() -> void:
	day = 0
	items.clear()
	StateManager.clear_state()
	StateManager.restore_global_state({})

static func begin_day(day_number: int) -> void:
	day = day_number
	var data := load_from_save()
	data.day = day_number
	data.items = items.duplicate()
	data.global_state = StateManager.export_global_state()
	save(data)

static func load_checkpoint() -> bool:
	var data := load_from_save()
	if data.day <= 0:
		return false
	day = data.day
	StateManager.clear_state()
	items.clear()
	for item_name in data.items:
		var key := str(item_name).strip_edges().to_upper()
		if InventoryItemGenerator.INVENTORY_ITEM.keys().has(key):
			items.append(key)
	var state: Dictionary = data.global_state if data.global_state is Dictionary else {}
	StateManager.restore_global_state(state)
	return true

static func remember_item(item_id: InventoryItemGenerator.INVENTORY_ITEM) -> void:
	var item_name: Variant = InventoryItemGenerator.INVENTORY_ITEM.find_key(item_id)
	if item_name == null:
		return
	items.append(str(item_name))

static func forget_item(item_id: InventoryItemGenerator.INVENTORY_ITEM) -> void:
	var item_name: Variant = InventoryItemGenerator.INVENTORY_ITEM.find_key(item_id)
	if item_name == null:
		return
	var index := items.find(str(item_name))
	if index >= 0:
		items.remove_at(index)

static func item_ids() -> Array[InventoryItemGenerator.INVENTORY_ITEM]:
	var result: Array[InventoryItemGenerator.INVENTORY_ITEM] = []
	for item_name in items:
		if InventoryItemGenerator.INVENTORY_ITEM.keys().has(item_name):
			result.append(InventoryItemGenerator.INVENTORY_ITEM[item_name])
	return result
