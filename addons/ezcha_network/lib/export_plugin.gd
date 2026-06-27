@tool
extends EditorExportPlugin

const _FEATURE_EXCLUDE_API_KEY: String = "ezcha_exclude_api_key"
const _FEATURE_EXCLUDE_SIGNING_KEY: String = "ezcha_exclude_signing_key"

var _restore_settings: Dictionary[EzchaOpts._Setting, Variant] = {}

func _get_name() -> String:
	return "Ezcha Network"

func _supports_platform(_platform: EditorExportPlatform) -> bool:
	return true

func _export_begin(features: PackedStringArray, is_debug: bool, _path: String, _flags: int) -> void:
	_restore_settings.clear()
	
	# Exclude secrets from builds that request it
	if (features.has(_FEATURE_EXCLUDE_API_KEY)):
		_restore_settings[EzchaOpts._Setting.API_KEY] = \
			EzchaOpts._get_setting(EzchaOpts._Setting.API_KEY)
	if (features.has(_FEATURE_EXCLUDE_SIGNING_KEY)):
		_restore_settings[EzchaOpts._Setting.SIGNING_KEY] = \
			EzchaOpts._get_setting(EzchaOpts._Setting.SIGNING_KEY)
	
	if (_restore_settings.is_empty()): return
	for setting: EzchaOpts._Setting in _restore_settings.keys():
		EzchaOpts._clear_setting(setting)
	ProjectSettings.save()

func _export_end() -> void:
	# Restore excluded settings
	if (_restore_settings.is_empty()): return
	for setting: EzchaOpts._Setting in _restore_settings.keys():
		EzchaOpts._restore_setting(setting, _restore_settings[setting])
	_restore_settings.clear()
	ProjectSettings.save()
