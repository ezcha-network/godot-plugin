@tool
extends EditorExportPlugin

const FEATURE_EXCLUDE_API_KEY: String = "ezcha_exclude_api_key"
const FEATURE_EXCLUDE_SIGNING_KEY: String = "ezcha_exclude_signing_key"
const SETTING_SESSION_OVERRIDE: String = "ezcha_network/config/debug/session_override"
const SETTING_API_KEY: String = "ezcha_network/config/server/api_key"
const SETTING_SIGNING_KEY: String = "ezcha_network/config/client/signing_key"

var restore_opts: Dictionary[String, String] = {}

func _get_name() -> String:
	return "Ezcha Network"

func _supports_platform(_platform: EditorExportPlatform) -> bool:
	return true

func _export_begin(features: PackedStringArray, is_debug: bool, _path: String, _flags: int) -> void:
	var backup_opts: PackedStringArray = []
	if (!is_debug):
		backup_opts.append(SETTING_SESSION_OVERRIDE)
	if (features.has(FEATURE_EXCLUDE_API_KEY)):
		backup_opts.append(SETTING_API_KEY)
	if (features.has(FEATURE_EXCLUDE_SIGNING_KEY)):
		backup_opts.append(SETTING_SIGNING_KEY)
	if (backup_opts.is_empty()): return
	for opt: String in backup_opts:
		if (!ProjectSettings.has_setting(opt)): continue
		restore_opts[opt] = ProjectSettings.get_setting(opt, "")
		ProjectSettings.clear(opt)
	ProjectSettings.save()

func _export_end() -> void:
	if (restore_opts.is_empty()): return
	for opt_key: String in restore_opts.keys():
		ProjectSettings.set_setting(opt_key, restore_opts[opt_key])
		ProjectSettings.set_initial_value(opt_key, "")
	restore_opts.clear()
	ProjectSettings.save()
