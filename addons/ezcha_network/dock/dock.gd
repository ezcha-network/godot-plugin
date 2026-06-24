@tool
extends Control

@onready var _ezcha: EzchaSingleton = get_node_or_null("/root/Ezcha")

var plugin: EzchaPlugin = null
var menu_main: ScrollContainer = null
var menu_information: ScrollContainer = null
var menu_trophies: ScrollContainer = null
var menu_leaderboards: ScrollContainer = null
var menu_configuration: ScrollContainer = null

func _enter_tree() -> void:
	# Get menu nodes
	menu_main = $Main
	menu_information = $Information
	menu_trophies = $Trophies
	menu_leaderboards = $Leaderboards
	menu_configuration = $Configuration
	
	# Initial game load
	if (plugin != null && !plugin._dock_initialized):
		plugin._dock_initialized = true
		load_game.call_deferred()

func _ready() -> void:
	show_menu(null)

func load_game() -> void:
	var game_id: String = ProjectSettings.get_setting("ezcha_network/config/global/game_id", "")
	if (game_id == ""): return show_menu(menu_configuration)
	var resp: EzchaGameResponse = await _ezcha.games.get_from_id(game_id).async()
	if (!resp.is_successful()):
		show_menu(menu_configuration)
		menu_configuration.update_game = true
		return
	plugin._game = resp.game
	show_menu(menu_main)

func show_menu(menu: Control) -> void:
	for child: Node in get_children():
		child.visible = (child == menu)
		if (!child.visible): continue
		child._opened()
		child.set_deferred("scroll_vertical", 0)
