tool
extends "res://addons/ezcha_network/dock/menu.gd"

onready var list: ItemList = $Contents/List
onready var copy_btn: Button = $Contents/Actions/Copy

func _opened() -> void:
	if (!dock.plugin.leaderboards_cached):
		dock.plugin.leaderboards_cached = true
		refresh_leaderboards()
		return
	render_list()

func reset() -> void:
	list.clear()
	copy_btn.disabled = true

func render_list() -> void:
	reset()
	for idx in dock.plugin.leaderboards.size():
		var leaderboard: EzchaLeaderboard = dock.plugin.leaderboards[idx]
		list.add_item(leaderboard.name)
		list.set_item_tooltip(idx, leaderboard.id)

func _on_get_leaderboard_response(resp: EzchaLeaderboardListResponse) -> void:
	if (!resp.is_successful()): return
	dock.plugin.leaderboards = resp.leaderboards
	render_list()

func refresh_leaderboards() -> void:
	reset()
	var resp: EzchaLeaderboardListResponse = _ezcha.games.get_leaderboards(dock.plugin.game.id)
	resp.connect("recieved", self, "_on_get_leaderboard_response", [], CONNECT_ONESHOT)

func _on_list_item_selected(index: int) -> void:
	var trophy: EzchaTrophyMeta = dock.plugin.trophies[index]
	copy_btn.disabled = false

func _on_copy_pressed() -> void:
	if (!list.is_anything_selected()): return
	var index: int = list.get_selected_items()[0]
	OS.set_clipboard(dock.plugin.leaderboards[index].id)

func _on_refresh_pressed():
	refresh_leaderboards()

func _on_back_pressed() -> void:
	dock.show_menu(dock.menu_main)
