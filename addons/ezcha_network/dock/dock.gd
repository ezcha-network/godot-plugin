@tool
extends Control

@onready var _ezcha: EzchaSingleton = EzchaSingleton._get_instance()

@onready var menu_container: PanelContainer = $VBox/Menu
@onready var menu_main: ScrollContainer = $VBox/Menu/Main
@onready var menu_information: ScrollContainer = $VBox/Menu/Information
@onready var menu_trophies: ScrollContainer = $VBox/Menu/Trophies
@onready var menu_leaderboards: ScrollContainer = $VBox/Menu/Leaderboards
@onready var menu_configuration: ScrollContainer = $VBox/Menu/Configuration

var plugin: EzchaPlugin = null

# Lifecycle

func _ready() -> void:
	# Initial game load
	if (plugin != null && !plugin._dock_initialized):
		plugin._dock_initialized = true
		_load_game.call_deferred()
	show_menu(null)

# Helpers

func _load_game() -> void:
	var game_id: String = _ezcha.get_game_id()
	if (game_id.is_empty()): return show_menu(menu_configuration)
	var resp: EzchaGameResponse = await _ezcha.games.get_from_id(game_id).async()
	if (!resp.is_successful()):
		show_menu(menu_configuration)
		return
	plugin._game = resp.game
	show_menu(menu_main)

func show_menu(menu: Control) -> void:
	for child: Node in menu_container.get_children():
		child.visible = (child == menu)
		if (!child.visible): continue
		child._opened()
		child.set_deferred("scroll_vertical", 0)

func toggle_bundle_progress(enabled: bool) -> void:
	var bundle_container: PanelContainer = $VBox/Bundle
	bundle_container.visible = enabled
	update_bundle_progress(0.0)

func update_bundle_status(status: String) -> void:
	var bundle_status: Label = $VBox/Bundle/VBox/Status
	bundle_status.text = status

func update_bundle_progress(progress: float) -> void:
	var bundle_progress_bar: ProgressBar = $VBox/Bundle/VBox/ProgressBar
	bundle_progress_bar.indeterminate = (progress < 0.0)
	bundle_progress_bar.value = clamp(progress, 0.0, 1.0)
