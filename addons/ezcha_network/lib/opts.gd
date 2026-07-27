extends RefCounted
class_name EzchaOpts
## A class for internal use.
##
## You should never need to use this directly.

enum _Setting {
	GAME_ID = 0,
	SIGNING_KEY = 1,
	API_KEY = 2,
	PRINT_REQUEST_ERRORS = 3,
	TEST_SESSION = 4
}

const _PRINT_PREFIX: String = "[Ezcha] "

const _SETTINGS_MAP: Array[Dictionary] = [
	{ "name": "ezcha_network/config/global/game_id", "value": "" },
	{ "name": "ezcha_network/config/client/signing_key", "value": "" },
	{ "name": "ezcha_network/config/server/api_key", "value": "" },
	{ "name": "ezcha_network/config/debug/print_request_errors", "value": false },
	{ "name": "ezcha_network/config/debug/test_session", "value": "", "init": false }
]
const _DEPRECATED_SETTINGS: Array[String] = [
	"ezcha_network/config/debug/session_override",
	"ezcha_network/config/debug/test_session"
]

const _FEATURE_IGNORE_TEST_SESSION = "ezcha_ignore_test_session"

const _DEV_CONFIG_PATH: String = "res://.ezcha_dev"

# Settings

static func _restore_setting(setting: _Setting, value: Variant = null) -> void:
	var setting_info: Dictionary = _SETTINGS_MAP[setting]
	if (!setting_info.get("init", true)): return
	var setting_name: String = setting_info["name"]
	var default_value: Variant = setting_info["value"]
	if (!ProjectSettings.has_setting(setting_name)):
		ProjectSettings.set_setting(
			setting_name,
			default_value if (value == null) else value
		)
	ProjectSettings.set_initial_value(setting_name, default_value)
	ProjectSettings.add_property_info({
		"name": setting_name,
		"type": typeof(default_value),
		"hint": setting_info.get("hint", PROPERTY_HINT_NONE),
		"hint_string": setting_info.get("hint_string", "")
	})

static func _prepare_settings() -> void:
	for depr_name: String in _DEPRECATED_SETTINGS:
		if (!ProjectSettings.has_setting(depr_name)): continue
		ProjectSettings.clear(depr_name)
	for setting: _Setting in _Setting.values():
		_restore_setting(setting)

static func _get_setting(setting: _Setting) -> Variant:
	return ProjectSettings.get_setting(
		_SETTINGS_MAP[setting]["name"], _SETTINGS_MAP[setting]["value"]
	)

static func _should_print_request_errors() -> bool:
	if (!Engine.is_editor_hint() && !OS.is_debug_build()): return false
	return _get_setting(_Setting.PRINT_REQUEST_ERRORS)

static func _get_test_session_temp() -> String:
	if (OS.has_feature(_FEATURE_IGNORE_TEST_SESSION)): return ""
	if (!Engine.is_editor_hint() && !OS.is_debug_build()): return ""
	return _get_setting(_Setting.TEST_SESSION)

static func _set_setting(setting: _Setting, value: Variant) -> void:
	ProjectSettings.set_setting(_SETTINGS_MAP[setting]["name"], value)

static func _clear_setting(setting: _Setting) -> void:
	ProjectSettings.clear(_SETTINGS_MAP[setting]["name"])

static func _cleanup_settings() -> void:
	for setting: Dictionary in _SETTINGS_MAP:
		if (!ProjectSettings.has_setting(setting["name"])): continue
		ProjectSettings.clear(setting["name"])

# Developer config

static func _load_dev_config() -> ConfigFile:
	if (!FileAccess.file_exists(_DEV_CONFIG_PATH)): return ConfigFile.new()
	var config: ConfigFile = ConfigFile.new()
	if (config.load(_DEV_CONFIG_PATH) != OK):
		printerr(_PRINT_PREFIX + "Failed to load developer configuration.")
		return null
	return config

static func _get_build_key() -> String:
	var config: ConfigFile = _load_dev_config()
	if (config == null): return ""
	return config.get_value("build", "api_key", "")

static func _get_test_session() -> String:
	var config: ConfigFile = _load_dev_config()
	if (config == null): return ""
	return config.get_value("developer", "test_session", "")

static func _save_dev_config(config: ConfigFile) -> void:
	# Add to .gitignore if missing
	if (!FileAccess.file_exists(_DEV_CONFIG_PATH)):
		if (FileAccess.file_exists("res://.gitignore")):
			var ignore_file: FileAccess = FileAccess.open("res://.gitignore", FileAccess.READ_WRITE)
			if (ignore_file == null):
				printerr(_PRINT_PREFIX + "Failed to save developer configuration. (0)")
				return
			var ignore_str: String = ignore_file.get_as_text()
			if (!ignore_str.contains(".ezcha_dev")):
				ignore_str += "\n# Ezcha Network\n.ezcha_dev\n"
				ignore_file.store_string(ignore_str)
			ignore_file.close()
	if (config.save(_DEV_CONFIG_PATH) == OK): return
	printerr(_PRINT_PREFIX + "Failed to save developer configuration. (1)")
