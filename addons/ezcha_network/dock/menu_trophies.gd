@tool
extends "res://addons/ezcha_network/dock/menu.gd"

const TROPHY_ICON: EzchaWebTexture = preload("res://addons/ezcha_network/dock/resources/trophy_icon.tres")

@onready var list: ItemList = $Contents/List
@onready var info_split: HBoxContainer = $Contents/InfoSplit
@onready var description_label: Label = $Contents/InfoSplit/Description
@onready var copy_btn: Button = $Contents/Actions/Copy

func _opened() -> void:
	if (!dock.plugin.trophies_cached):
		dock.plugin.trophies_cached = true
		refresh_trophies()
		return
	render_list()

func reset() -> void:
	list.clear()
	copy_btn.disabled = true
	info_split.visible = false

func render_list() -> void:
	reset()
	for trophy: EzchaTrophyMeta in dock.plugin.trophies:
		var idx: int = list.add_item(trophy.name)
		list.set_item_tooltip(idx, trophy.id)

func refresh_trophies() -> void:
	reset()
	var resp: EzchaTrophyMetaListResponse = _ezcha.games.get_trophies(dock.plugin.game.id)
	await resp.recieved
	if (!resp.is_successful()): return
	dock.plugin.trophies = resp.trophies
	render_list()

func _on_list_item_selected(index: int) -> void:
	var trophy: EzchaTrophyMeta = dock.plugin.trophies[index]
	copy_btn.disabled = false
	info_split.visible = true
	description_label.text = trophy.description
	TROPHY_ICON.fetch(trophy.icon_url)

func _on_copy_pressed() -> void:
	if (!list.is_anything_selected()): return
	var index: int = list.get_selected_items()[0]
	DisplayServer.clipboard_set(dock.plugin.trophies[index].id)

func _on_refresh_pressed() -> void:
	refresh_trophies()

func _on_back_pressed() -> void:
	dock.show_menu(dock.menu_main)
