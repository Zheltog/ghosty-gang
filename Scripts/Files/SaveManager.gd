class_name SaveManager

static var save_file_name = "user://save.v1.data"

static var _cached_save: SaveData = null

static func save(data: SaveData) -> void:
	var dictionary = data.to_dictionary()
	#print(str("[SaveManager] Saving data: ", dictionary))
	StorageManager.write_json_to(save_file_name, dictionary)
	_cached_save = null
	#print("[SaveManager] Cached save has been removed successfully")

static func load() -> SaveData:
	if _cached_save != null:
		return _cached_save
	var dictionary = StorageManager.read_json_from(save_file_name)
	#print(str("[SaveManager] Loaded save data: ", dictionary))
	_cached_save = SaveData.new(dictionary)
	#print("[SaveManager] Cached save has been updated successfully")
	return _cached_save
