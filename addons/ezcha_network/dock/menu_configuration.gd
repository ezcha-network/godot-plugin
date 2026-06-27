@tool
extends "res://addons/ezcha_network/dock/menu.gd"

@onready var error_label = $Contents/ErrorLabel
@onready var inputs: Array[Control] = [
	$Contents/Project/GameIdEdit,
	$Contents/Project/SigningKeyEdit,
	$Contents/Project/ApiKeyEdit,
	$Contents/Development/TestSessionEdit,
	$Contents/Development/BuildKeyEdit,
	$Contents/Development/PrintRequestErrorsCheckButton,
	$Contents/Done
]

func _opened() -> void:
	$Contents/Project/GameIdEdit.text = ezcha.get_game_id()
	$Contents/Project/SigningKeyEdit.text = ezcha.get_signing_key()
	$Contents/Project/ApiKeyEdit.text = ezcha.get_api_key()
	$Contents/Development/TestSessionEdit.text = EzchaOpts._get_test_session()
	$Contents/Development/BuildKeyEdit.text = EzchaOpts._get_build_key()
	$Contents/Development/PrintRequestErrorsCheckButton.button_pressed = EzchaOpts._should_print_request_errors()
	unlock_inputs()

func lock_inputs() -> void:
	for i: Control in inputs:
		if (i is LineEdit): i.editable = false
		elif (i is Button): i.disabled = true

func unlock_inputs() -> void:
	for i: Control in inputs:
		if (i is LineEdit): i.editable = true
		elif (i is Button): i.disabled = false

func show_error(err_text: String) -> void:
	error_label.text = err_text
	error_label.visible = true
	RenderingServer.frame_post_draw.connect(func():
		scroll_vertical = 999999999
	, CONNECT_ONE_SHOT)

func hide_error() -> void:
	error_label.visible = false

func _on_done_pressed() -> void:
	# Get inputs
	hide_error()
	var clear_cache: bool = false
	var game_id: String = $Contents/Project/GameIdEdit.text
	var signing_key: String = $Contents/Project/SigningKeyEdit.text
	var api_key: String = $Contents/Project/ApiKeyEdit.text
	var test_session: String = $Contents/Development/TestSessionEdit.text
	var build_key: String = $Contents/Development/BuildKeyEdit.text
	var print_err: bool = $Contents/Development/PrintRequestErrorsCheckButton.button_pressed
	
	# Validate
	if (game_id.strip_edges() == ""): return show_error("Game ID is required.")
	lock_inputs()
	
	# Check game
	var current_game_id: String = ezcha.get_game_id()
	if (game_id != current_game_id):
		var resp: EzchaGameResponse = await ezcha.games.get_from_id(game_id).async()
		if (!resp.is_successful()):
			var resp_err: String = resp.get_error()
			show_error(
				resp_err if !resp_err.is_empty() else
				"An error has ocurred. (%s)" % [str(resp.get_status())]
			)
			unlock_inputs()
			return
		plugin._game = resp.game
		clear_cache = true
	
	# Check new session token
	if (test_session != EzchaOpts._get_test_session()):
		if (!test_session.is_empty()):
			var validate_res: EzchaSessionValidationResponse = await ezcha.sessions.post_validation(
				test_session, game_id
			).async()
			if (!validate_res.is_successful()):
				show_error("Test session is invalid.")
				unlock_inputs()
				return
		clear_cache = true
	
	# Clear cache
	if (clear_cache):
		plugin._trophies_cached = false
		plugin._trophies.clear()
		plugin._leaderboards_cached = false
		plugin._leaderboards.clear()
	
	# Update project settings
	EzchaOpts._set_setting(EzchaOpts._Setting.GAME_ID, game_id)
	EzchaOpts._set_setting(EzchaOpts._Setting.SIGNING_KEY, signing_key)
	EzchaOpts._set_setting(EzchaOpts._Setting.API_KEY, api_key)
	EzchaOpts._set_setting(EzchaOpts._Setting.PRINT_REQUEST_ERRORS, print_err)
	ProjectSettings.save()
	
	# Update developer config
	var config: ConfigFile = EzchaOpts._load_dev_config()
	if (config != null):
		config.set_value("build", "api_key", build_key)
		config.set_value("developer", "test_session", test_session)
		EzchaOpts._save_dev_config(config)
	
	dock.show_menu(dock.menu_main)
