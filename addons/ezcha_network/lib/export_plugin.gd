@tool
extends EditorExportPlugin

const SESSION_OVERRIDE_SETTING: String = "ezcha_network/config/debug/session_override"

var restore_session_override: String = ""

func _get_name() -> String:
	return "Ezcha Network"

func _supports_platform(_platform: EditorExportPlatform) -> bool:
	return true

func _export_begin(_features: PackedStringArray, is_debug: bool, _path: String, _flags: int) -> void:
	if (is_debug): return
	if (!ProjectSettings.has_setting(SESSION_OVERRIDE_SETTING)) : return
	restore_session_override = ProjectSettings.get_setting(SESSION_OVERRIDE_SETTING, "")
	ProjectSettings.clear(SESSION_OVERRIDE_SETTING)
	ProjectSettings.save()

func _export_end() -> void:
	if (restore_session_override == ""): return
	# Restore session override
	ProjectSettings.set_setting(SESSION_OVERRIDE_SETTING, restore_session_override)
	ProjectSettings.set_initial_value(SESSION_OVERRIDE_SETTING, "")
	ProjectSettings.save()
