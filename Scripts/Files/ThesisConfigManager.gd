class_name ThesisConfigManager

static var config_file_name_prefix = "res://Files/"
static var config_file_name_postfix = "/theses.json"

static var _cached_language: String = ""
static var _cached_config: ThesisConfig = null

static func load() -> ThesisConfig:
	var language = SaveManager.load().lang
	if _cached_language == language and _cached_config != null:
		return _cached_config
	var dictionary = StorageManager.read_json_from(_build_config_file_name(language))
	#print(str("[ThesisConfigManager] Loaded config: ", dictionary))
	_cached_language = language
	_cached_config = ThesisConfig.new(dictionary)
	#print("[ThesisConfigManager] Cached config has been updated successfully")
	return _cached_config

static func get_theses_by_group_known(group: String) -> Array:
	var save = SaveManager.load()
	return ThesisConfigManager.load().get_by_group_known(group, save.known_theses)

static func _build_config_file_name(language: String) -> String:
	return str(config_file_name_prefix, language, config_file_name_postfix)
