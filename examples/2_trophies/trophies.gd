extends Control

@onready var list: ItemList = $Center/HBox/Browse/VBox/List

@onready var info_panel: PanelContainer = $Center/HBox/Info
@onready var icon: TextureRect = $Center/HBox/Info/VBox/HBoxContainer/Icon
@onready var trophy_name: Label = $Center/HBox/Info/VBox/HBoxContainer/VBox/Name
@onready var experience: Label = $Center/HBox/Info/VBox/HBoxContainer/VBox/Experience
@onready var description: TextEdit = $Center/HBox/Info/VBox/Description

var trophies: Array[EzchaTrophy] = []

func _ready() -> void:
	# Prepare UI stuff.
	info_panel.hide()
	
	# Request the trophy list from the API.
	var game_id: String = Ezcha.get_game_id()
	var trophies_res: EzchaTrophyListResponse = \
		await Ezcha.games.get_trophies(game_id).async()
	
	# Check if the request failed.
	if (!trophies_res.is_successful()):
		printerr("Failed to load trophies.")
		return
	trophies = trophies_res.trophies
	
	# Populate ItemList node.
	for trophy: EzchaTrophy in trophies:
		list.add_item(trophy.name)

func _on_list_item_selected(index: int) -> void:
	# Show the information of the selected trophy.
	var trophy: EzchaTrophy = trophies[index]
	icon.texture.url = trophy.icon_url
	trophy_name.text = trophy.name
	experience.text = "%d experience" % [trophy.experience_points]
	description.text = trophy.description
	info_panel.show()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://examples/0_authentication/authentication.tscn")

func _on_grant_pressed() -> void:
	# Get the selected trophy.
	var selected: PackedInt32Array = list.get_selected_items()
	if (selected.is_empty()): return
	var trophy: EzchaTrophy = trophies[selected[0]]
	
	# Grant it to the authenticated user.
	var granted: bool = await Ezcha.client.grant_trophy(trophy.id)
	
	# Check the grant response.
	if (granted): print("Granted trophy %s!" % [trophy.name])
	else: printerr("Failed to grant %s." % [trophy.name])

# Pssst. If you really want to get Trophy C here's an API key.
# OZN9PRnyADvuxZK-aBMSkEpR.MSsHepJ-4R4Oc9K8bbelV5Dp
