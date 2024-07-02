@tool
extends Control

@onready var _ezcha: Node = get_node_or_null("/root/Ezcha")

var plugin: EzchaPlugin = null
var menu_main: ScrollContainer
var menu_information: ScrollContainer
var menu_trophies: ScrollContainer
var menu_leaderboards: ScrollContainer
var menu_configuration: ScrollContainer

func _enter_tree():
	# Get menu nodes
	menu_main = $Main
	menu_information = $Information
	menu_trophies = $Trophies
	menu_leaderboards = $Leaderboards
	menu_configuration = $Configuration
	
	# Initial game load
	if (plugin != null && !plugin.dock_initialized):
		plugin.dock_initialized = true
		load_game.call_deferred()

func _ready() -> void:
	show_menu(null)

func load_game() -> void:
	var game_id: String = ProjectSettings.get_setting("ezcha_network/config/global/game_id", "")
	if (game_id == ""):
		return show_menu(menu_configuration)
	
	var resp: EzchaGameResponse = _ezcha.games.get_from_id(game_id)
	await resp.recieved
	if (!resp.is_successful()):
		show_menu(menu_configuration)
		menu_configuration.update_game = true
		return
	plugin.game = resp.game
	show_menu(menu_main)

func show_menu(menu: Control) -> void:
	for child in get_children():
		child.visible = (child == menu)
		if (child.visible):
			child._opened()
			child.set_deferred("scroll_vertical", 0)
