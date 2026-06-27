extends Control

@onready var list: ItemList = $Center/HBox/Browse/VBox/List

@onready var info_panel: PanelContainer = $Center/HBox/Info
@onready var leaderboard_name: Label = $Center/HBox/Info/VBox/Name
@onready var tree: Tree = $Center/HBox/Info/VBox/Tree
@onready var score: SpinBox = $Center/HBox/Info/VBox/HBox/Score

var leaderboards: Array[EzchaLeaderboard] = []

func _ready() -> void:
	# Prepare UI stuff.
	info_panel.hide()
	tree.set_column_title(0, "Rank")
	tree.set_column_title(1, "Name")
	tree.set_column_title(2, "Score")
	
	# Request the leaderboard list from the API.
	var game_id: String = Ezcha.get_game_id()
	var leaderboards_res: EzchaLeaderboardListResponse = \
		await Ezcha.games.get_leaderboards(game_id).async()
	
	# Check if the request failed.
	if (!leaderboards_res.is_successful()):
		printerr("Failed to load leaderboards.")
		return
	leaderboards = leaderboards_res.leaderboards
	
	# Populate ItemList node.
	for leaderboard: EzchaLeaderboard in leaderboards:
		list.add_item(leaderboard.name)

func display_leaderboard(leaderboard: EzchaLeaderboard) -> void:
	# Prepare the UI for the selected leaderboard.
	leaderboard_name.text = "Loading..."
	tree.clear()
	var tree_root: TreeItem = tree.create_item()
	info_panel.show()
	
	# Request entries of the selected leaderboard.
	var entries_res: EzchaLeaderboardEntryListResponse = \
		await Ezcha.leaderboards.get_entries(leaderboard.id).async()
	
	# Check the response.
	if (!entries_res.is_successful()):
		printerr("Failed to load entries for %s." % [leaderboard.name])
		return
	
	# Show the name of the leaderboard.
	leaderboard_name.text = leaderboard.name
	
	# Populate the Tree node with leaderboard entries.
	for entry: EzchaLeaderboardEntry in entries_res.entries:
		var item: TreeItem = tree_root.create_child()
		item.set_text(0, "#%d" % [entry.ranking])
		item.set_text(1, entry.user.name)
		item.set_text(2, str(entry.score))

func _on_list_item_selected(index: int) -> void:
	# Get the selected leaderboard.
	var leaderboard: EzchaLeaderboard = leaderboards[index]
	# Update the display.
	display_leaderboard(leaderboard)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://examples/0_authentication/authentication.tscn")

func _on_submit_pressed() -> void:
	# Get the selected leaderboard.
	var selected: PackedInt32Array = list.get_selected_items()
	if (selected.is_empty()): return
	var leaderboard: EzchaLeaderboard = leaderboards[selected[0]]
	
	# Update the user's score for the selected leaderboard.
	var updated: bool = await Ezcha.client.update_score(leaderboard.id, score.value)
	
	# Check the update response.
	if (!updated):
		printerr("Failed to updated score on %s." % [leaderboard.name])
		return
	print("Score updated on %s!" % [leaderboard.name])
	display_leaderboard(leaderboard) # Refresh the display.
