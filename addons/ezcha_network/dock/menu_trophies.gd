@tool
extends "res://addons/ezcha_network/dock/menu.gd"

@onready var list: ItemList = $Contents/List
@onready var info_split: HBoxContainer = $Contents/InfoSplit
@onready var icon: TextureRect = $Contents/InfoSplit/Icon
@onready var description_label: Label = $Contents/InfoSplit/Description
@onready var copy_btn: Button = $Contents/Actions/Copy

func _opened() -> void:
	if (!plugin._trophies_cached):
		plugin._trophies_cached = true
		refresh_trophies()
		return
	render_list()

func reset() -> void:
	list.clear()
	copy_btn.disabled = true
	info_split.visible = false

func render_list() -> void:
	reset()
	for trophy: EzchaTrophy in plugin._trophies:
		var idx: int = list.add_item(trophy.name)
		list.set_item_tooltip(idx, trophy.id)

func refresh_trophies() -> void:
	reset()
	var resp: EzchaTrophyListResponse = await ezcha.games.get_trophies(
		plugin._game.id, EzchaOpts._get_test_session()
	).async()
	if (!resp.is_successful()): return
	plugin._trophies = resp.trophies
	render_list()

func _on_list_item_selected(index: int) -> void:
	var trophy: EzchaTrophy = plugin._trophies[index]
	copy_btn.disabled = false
	info_split.visible = true
	description_label.text = trophy.description
	icon.texture.url = trophy.icon_url

func _on_copy_pressed() -> void:
	if (!list.is_anything_selected()): return
	var index: int = list.get_selected_items()[0]
	DisplayServer.clipboard_set(plugin._trophies[index].id)

func _on_refresh_pressed() -> void:
	refresh_trophies()

func _on_back_pressed() -> void:
	dock.show_menu(dock.menu_main)
