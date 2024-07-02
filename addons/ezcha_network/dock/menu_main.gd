tool
extends "res://addons/ezcha_network/dock/menu.gd"

func _on_info_pressed() -> void:
	dock.show_menu(dock.menu_information)

func _on_trophies_pressed() -> void:
	dock.show_menu(dock.menu_trophies)

func _on_leaderboards_pressed():
	dock.show_menu(dock.menu_leaderboards)

func _on_dev_panel_pressed() -> void:
	OS.shell_open("https://ezcha.net/developer/%s" % [dock.plugin.game.id])

func _on_configuration_pressed() -> void:
	dock.show_menu(dock.menu_configuration)

func _on_docs_pressed() -> void:
	OS.shell_open("https://github.com/ezcha-network/godot-plugin/blob/godot-3.x/docs.md")

func _on_repo_pressed() -> void:
	OS.shell_open("https://github.com/ezcha-network/godot-plugin/tree/godot-3.x")

func _on_forums_pressed() -> void:
	OS.shell_open("https://ezcha.net/forums/developers")
