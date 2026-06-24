@tool
extends EditorPlugin
class_name EzchaPlugin
## A class for internal use.
##
## You should never need to use this directly.
## The "EzchaSingleton" class is a good starting point.
##
## Many of the values here are used for the dock within the editor and will not
## be available within an exported game.

const _EXPORT_PLUGIN: Script = preload("res://addons/ezcha_network/lib/export_plugin.gd")
const _SETTINGS_MAP: Array[Dictionary] = [
	{ "name": "ezcha_network/config/global/game_id", "value": "" },
	{ "name": "ezcha_network/config/client/signing_key", "value": "" },
	{ "name": "ezcha_network/config/server/api_key", "value": "" },
	{ "name": "ezcha_network/config/debug/session_override", "value": "" },
	{ "name": "ezcha_network/config/debug/print_request_errors", "value": false }
]

var _export_plugin: EditorExportPlugin = null

var _dock: Control = null
var _dock_initialized: bool = false

var _keep_alive_timer: Timer = null

var _game: EzchaGame = null
var _trophies_cached: bool = false
var _trophies: Array[EzchaTrophy] = []
var _leaderboards_cached: bool = false
var _leaderboards: Array[EzchaLeaderboard] = []

func _enter_tree() -> void:
	# Create settings
	for setting: Dictionary in _SETTINGS_MAP:
		if (!ProjectSettings.has_setting(setting["name"])):
			ProjectSettings.set_setting(setting["name"], setting["value"])
		ProjectSettings.set_initial_value(setting["name"], setting["value"])
		ProjectSettings.add_property_info({
			"name": setting["name"],
			"type": typeof(setting["value"]),
			"hint": setting.get("hint", PROPERTY_HINT_NONE),
			"hint_string": setting.get("hint_string", "")
		})
	
	# Add singleton
	add_autoload_singleton("Ezcha", "res://addons/ezcha_network/lib/singleton.gd")
	
	# Enable export plugin
	_export_plugin = _EXPORT_PLUGIN.new()
	add_export_plugin(_export_plugin)
	
	# Add dock
	_dock = load("res://addons/ezcha_network/dock/dock.tscn").instantiate()
	_dock.plugin = self
	add_control_to_dock.call_deferred(DOCK_SLOT_RIGHT_BL, _dock)
	
	# Create keep alive timer
	_keep_alive_timer = Timer.new()
	_keep_alive_timer.wait_time = 300.0
	_keep_alive_timer.autostart = true
	_keep_alive_timer.timeout.connect(_on_keep_alive_timeout)
	add_child(_keep_alive_timer)

func _common_cleanup() -> void:
	# Free dock
	if (_dock == null): return
	remove_control_from_docks(_dock)
	_dock.free()
	_dock = null

func _exit_tree() -> void:
	_common_cleanup()
	
	# Disable export plugin
	remove_export_plugin(_export_plugin)
	_export_plugin = null

func _disable_plugin() -> void:
	# Clear settings
	for setting: Dictionary in _SETTINGS_MAP:
		if (!ProjectSettings.has_setting(setting["name"])): continue
		ProjectSettings.clear(setting["name"])
	
	_common_cleanup()
	
	# Remove singleton
	remove_autoload_singleton("Ezcha")

func _on_keep_alive_timeout() -> void:
	var singleton: EzchaSingleton = get_node_or_null("/root/Ezcha")
	if (singleton == null): return
	var game_id: String = singleton.get_game_id()
	var session: String = singleton.get_session_override()
	if (game_id.is_empty() || session.is_empty()): return
	
	var validate_res: EzchaSessionValidationResponse = await singleton.sessions.post_validation(session, game_id).async()
	if (validate_res.is_successful()):
		print_rich("[color=#FFFFFF80][i]Ezcha session override refreshed.[/i][/color]")
		return
	ProjectSettings.clear("ezcha_network/config/debug/session_override")
	print_rich("[color=#FFFFFF80][i]Ezcha session override expired.[/i][/color]")
