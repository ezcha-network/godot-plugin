@tool
extends "res://addons/ezcha_network/dock/menu.gd"

const GAME_BANNER: EzchaWebTexture = preload("res://addons/ezcha_network/dock/resources/game_banner.tres")

func _opened() -> void:
	$Contents/InfoGrid/IdValue.text = dock.plugin._game.id
	$Contents/InfoGrid/NameValue.text = dock.plugin._game.name
	$Contents/InfoGrid/VersionValue.text = dock.plugin._game.version
	GAME_BANNER.fetch(dock.plugin._game.banner_url)

func _on_back_pressed() -> void:
	dock.show_menu(dock.menu_main)
