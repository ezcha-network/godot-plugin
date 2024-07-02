@tool
extends "res://addons/ezcha_network/dock/menu.gd"

const GAME_BANNER: EzchaWebTexture = preload("res://addons/ezcha_network/dock/resources/game_banner.tres")

func _opened() -> void:
	$Contents/InfoGrid/IdValue.text = dock.plugin.game.id
	$Contents/InfoGrid/NameValue.text = dock.plugin.game.name
	$Contents/InfoGrid/VersionValue.text = dock.plugin.game.version
	GAME_BANNER.fetch(dock.plugin.game.banner_url)

func _on_back_pressed():
	dock.show_menu(dock.menu_main)
