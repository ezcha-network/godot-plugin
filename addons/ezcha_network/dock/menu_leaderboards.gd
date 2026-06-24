@tool
extends "res://addons/ezcha_network/dock/menu.gd"

@onready var list: ItemList = $Contents/List
@onready var copy_btn: Button = $Contents/Actions/Copy

func _opened() -> void:
	if (!dock.plugin._leaderboards_cached):
		dock.plugin._leaderboards_cached = true
		refresh_leaderboards()
		return
	render_list()

func reset() -> void:
	list.clear()
	copy_btn.disabled = true

func render_list() -> void:
	reset()
	for leaderboard: EzchaLeaderboard in dock.plugin._leaderboards:
		var idx: int = list.add_item(leaderboard.name)
		list.set_item_tooltip(idx, leaderboard.id)

func refresh_leaderboards() -> void:
	reset()
	var resp: EzchaLeaderboardListResponse = await _ezcha.games.get_leaderboards(
		dock.plugin._game.id, _ezcha.get_session_override()
	).async()
	if (!resp.is_successful()): return
	dock.plugin._leaderboards = resp.leaderboards
	render_list()

func _on_list_item_selected(index: int) -> void:
	var leaderboard: EzchaLeaderboard = dock.plugin._leaderboards[index]
	copy_btn.disabled = false

func _on_copy_pressed() -> void:
	if (!list.is_anything_selected()): return
	var index: int = list.get_selected_items()[0]
	DisplayServer.clipboard_set(dock.plugin._leaderboards[index].id)

func _on_refresh_pressed() -> void:
	refresh_leaderboards()

func _on_back_pressed() -> void:
	dock.show_menu(dock.menu_main)
