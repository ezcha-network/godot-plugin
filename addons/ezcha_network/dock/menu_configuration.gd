@tool
extends "res://addons/ezcha_network/dock/menu.gd"

@onready var error_label = $Contents/ErrorLabel
@onready var inputs: Array[Control] = [
	$Contents/Global/GameIdEdit,
	$Contents/Client/SigningKeyEdit,
	$Contents/Server/ApiKeyEdit,
	$Contents/Debug/SessionOverrideEdit,
	$Contents/Debug/PrintRequestErrorsCheckButton,
	$Contents/Done
]
var update_game: bool = false
var clear_cache: bool = false

func _opened():
	update_game = false
	clear_cache = false
	$Contents/Global/GameIdEdit.text = _ezcha.get_game_id()
	$Contents/Client/SigningKeyEdit.text = _ezcha.get_signing_key()
	$Contents/Server/ApiKeyEdit.text = _ezcha.get_api_key()
	$Contents/Debug/SessionOverrideEdit.text = _ezcha.get_session_override()
	$Contents/Debug/PrintRequestErrorsCheckButton.button_pressed = _ezcha.should_print_request_errors()
	unlock_inputs()

func lock_inputs():
	for i in inputs:
		if (i is LineEdit): i.editable = false
		elif (i is Button): i.disabled = true

func unlock_inputs():
	for i in inputs:
		if (i is LineEdit): i.editable = true
		elif (i is Button): i.disabled = false

func show_error(err_text: String):
	error_label.text = err_text
	error_label.visible = true
	set_deferred("scroll_vertical", 999999999) # idk

func hide_error():
	error_label.visible = false

func _on_game_id_edit_text_changed(text: String) -> void:
	ProjectSettings.set_setting("ezcha_network/config/global/game_id", text)
	update_game = true
	clear_cache = true

func _on_signing_key_edit_text_changed(text: String) -> void:
	ProjectSettings.set_setting("ezcha_network/config/client/signing_key", text)

func _on_api_key_edit_text_changed(text: String) -> void:
	ProjectSettings.set_setting("ezcha_network/config/server/api_key", text)

func _on_session_override_edit_text_changed(text: String) -> void:
	ProjectSettings.set_setting("ezcha_network/config/debug/session_override", text)
	clear_cache = true

func _on_print_request_errors_checkbox_toggled(toggled: bool):
	ProjectSettings.set_setting("ezcha_network/config/debug/print_request_errors", toggled)

func _on_done_pressed() -> void:
	hide_error()
	
	# Validate
	var game_id: String = ProjectSettings.get_setting("ezcha_network/config/global/game_id", "")
	if (game_id.strip_edges() == ""): return show_error("Game ID is required.")
	
	lock_inputs()
	
	# Clear cache if needed
	if (clear_cache):
		dock.plugin.trophies_cached = false
		dock.plugin.trophies.clear()
		dock.plugin.leaderboards_cached = false
		dock.plugin.leaderboards.clear()
	
	# Update game data if needed
	if (!update_game):
		ProjectSettings.save()
		dock.show_menu(dock.menu_main)
		return
	var resp: EzchaGameResponse = _ezcha.games.get_from_id(game_id)
	await resp.recieved
	if (resp.is_successful()):
		ProjectSettings.save()
		dock.plugin.game = resp.game
		dock.show_menu(dock.menu_main)
		return
	
	# Failed :(
	if (resp.get_error() != ""): show_error(resp.get_error())
	else: show_error("An error has ocurred. (%s)" % [str(resp.get_status())])
	unlock_inputs()
