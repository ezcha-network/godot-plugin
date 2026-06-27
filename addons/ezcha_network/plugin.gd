@tool
extends EditorPlugin
class_name EzchaPlugin
## A class for internal use.
##
## You should never need to use this directly.
## The "EzchaSingleton" class is a good starting point.

var _export_platform: EditorExportPlatformExtension = null
var _export_plugin: EditorExportPlugin = null

var _dock: Control = null
var _dock_initialized: bool = false

var _keep_alive_timer: Timer = null

var _game: EzchaGame = null
var _trophies_cached: bool = false
var _trophies: Array[EzchaTrophy] = []
var _leaderboards_cached: bool = false
var _leaderboards: Array[EzchaLeaderboard] = []

# Lifecycle

func _enter_tree() -> void:
	# Prepare settings
	EzchaOpts._prepare_settings()
	if (!EzchaOpts._get_test_session().is_empty()): _refresh_test_session()
	
	# Add singleton
	add_autoload_singleton("Ezcha", "res://addons/ezcha_network/lib/singleton.gd")
	
	# Enable export platform
	var export_platform_scr: Script = load("res://addons/ezcha_network/lib/export_platform.gd")
	_export_platform = export_platform_scr.new(self)
	add_export_platform(_export_platform)
	
	# Enable export plugin
	var export_plugin_scr: Script = load("res://addons/ezcha_network/lib/export_plugin.gd")
	_export_plugin = export_plugin_scr.new()
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

func _exit_tree() -> void:
	_common_cleanup()
	
	# Disable export platform
	remove_export_platform(_export_platform)
	_export_platform = null
	
	# Disable export plugin
	remove_export_plugin(_export_plugin)
	_export_plugin = null

func _disable_plugin() -> void:
	# Clear settings
	EzchaOpts._cleanup_settings()
	
	_common_cleanup()
	
	# Remove singleton
	remove_autoload_singleton("Ezcha")

func _get_unsaved_status(for_scene: String) -> String:
	if (!for_scene.is_empty()): return ""
	if (_export_platform != null && _export_platform._is_running()):
		return "An export to Ezcha Network is currently in progress.\nQuitting now may cause unexpected behavior."
	return ""

func _build() -> bool:
	# Reject if busy exporting
	if (_export_platform != null && _export_platform._is_running()):
		OS.alert("An export to Ezcha Network is currently in progress. Please wait until it is finished.")
		return false
	# Inject test session setting
	var session: String = EzchaOpts._get_test_session()
	if (session.is_empty()): return true
	EzchaOpts._set_setting(EzchaOpts._Setting.TEST_SESSION, session)
	ProjectSettings.save()
	_post_build.call_deferred()
	return true

func _post_build() -> void:
	EzchaOpts._clear_setting.call_deferred(EzchaOpts._Setting.TEST_SESSION)
	ProjectSettings.save()

# Internal helpers

func _common_cleanup() -> void:
	# Shut down export
	if (_export_platform != null):
		_export_platform._shutdown()
	
	# Free dock
	if (_dock == null): return
	remove_control_from_docks(_dock)
	_dock.free()
	_dock = null

func _refresh_test_session() -> void:
	var ezcha: EzchaSingleton = EzchaSingleton._get_instance()
	if (ezcha == null): return
	
	var game_id: String = EzchaOpts._get_setting(EzchaOpts._Setting.GAME_ID)
	var test_session: String = EzchaOpts._get_test_session()
	if (game_id.is_empty() || test_session.is_empty()): return
	
	var validate_res: EzchaSessionValidationResponse = await ezcha.sessions.post_validation(
		test_session, game_id
	).async()
	if (validate_res.is_successful()):
		print_rich(
			"[color=#FFFFFF80]%sTest session refreshed.[/color]" % [EzchaOpts._PRINT_PREFIX]
		)
		return
	# Clear the expired session from the developer config
	var config: ConfigFile = EzchaOpts._load_dev_config()
	if (config != null):
		config.set_value("developer", "test_session", "")
		EzchaOpts._save_dev_config(config)
	print_rich("[color=#FFFFFF80]%sTest session expired.[/color]" % [EzchaOpts._PRINT_PREFIX])

# Events

func _on_keep_alive_timeout() -> void:
	_refresh_test_session()
