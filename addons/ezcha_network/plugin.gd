@tool
extends EditorPlugin
class_name EzchaPlugin

const _SETTINGS_MAP: Array[Dictionary] = [
	{ "name": "ezcha_network/config/global/game_id", "value": "" },
	{ "name": "ezcha_network/config/client/signing_key", "value": "" },
	{ "name": "ezcha_network/config/server/api_key", "value": "" },
	{ "name": "ezcha_network/config/debug/session_override", "value": "" }
]

var dock: Control = null
var dock_initialized: bool = false
var game: EzchaGame = null
var trophies_cached: bool = false
var trophies: Array[EzchaTrophyMeta] = []
var leaderboards_cached: bool = false
var leaderboards: Array[EzchaLeaderboard] = []

func _enter_tree() -> void:
	# Create settings
	for setting in _SETTINGS_MAP:
		if (ProjectSettings.has_setting(setting["name"])): continue
		ProjectSettings.set_setting(setting["name"], setting["value"])
		ProjectSettings.set_initial_value(setting["name"], setting["value"])
		var info: Dictionary = {
			"name": setting["name"],
			"type": typeof(setting["value"]),
		}
		ProjectSettings.add_property_info(info)
	
	# Add singleton
	add_autoload_singleton("Ezcha", "res://addons/ezcha_network/lib/singleton.gd")
	
	# Add dock
	dock = load("res://addons/ezcha_network/dock/dock.tscn").instantiate()
	dock.plugin = self
	add_control_to_dock.call_deferred(DOCK_SLOT_RIGHT_BL, dock)

func _common_cleanup() -> void:
	# Free dock
	if (dock == null): return
	remove_control_from_docks(dock)
	dock.free()
	dock = null

func _exit_tree() -> void:
	_common_cleanup()

func _disable_plugin() -> void:
	# Clear settings
	for setting in _SETTINGS_MAP:
		if (!ProjectSettings.has_setting(setting["name"])): continue
		ProjectSettings.clear(setting["name"])
	
	_common_cleanup()
	
	# Remove singleton
	remove_autoload_singleton("Ezcha")
