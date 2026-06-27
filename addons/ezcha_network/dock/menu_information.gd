@tool
extends "res://addons/ezcha_network/dock/menu.gd"

func _opened() -> void:
	$Contents/InfoGrid/IdValue.text = plugin._game.id
	$Contents/InfoGrid/NameValue.text = plugin._game.name
	$Contents/InfoGrid/VersionValue.text = plugin._game.version
	$Contents/Banner.texture.url = plugin._game.banner_url

func _on_back_pressed() -> void:
	dock.show_menu(dock.menu_main)
