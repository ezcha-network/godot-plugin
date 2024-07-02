tool
extends Control

onready var _ezcha: Node = get_node_or_null("/root/Ezcha")

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
		call_deferred("load_game")

func _ready() -> void:
	show_menu(null)

func _on_game_response(resp: EzchaGameResponse) -> void:
	if (!resp.is_successful()):
		show_menu(menu_configuration)
		menu_configuration.update_game = true
		return
	plugin.game = resp.game
	show_menu(menu_main)

func load_game() -> void:
	var game_id: String = ProjectSettings.get_setting("ezcha_network/config/global/game_id")
	if (game_id == null || game_id == ""):
		show_menu(menu_configuration)
		return
	
	var resp: EzchaGameResponse = _ezcha.games.get_from_id(game_id)
	resp.connect("recieved", self, "_on_game_response", [], CONNECT_ONESHOT)

func show_menu(menu: Control) -> void:
	for child in get_children():
		child.visible = (child == menu)
		if (child.visible):
			child._opened()
			child.set_deferred("scroll_vertical", 0)
