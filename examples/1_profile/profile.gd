extends Control

func _ready() -> void:
	# Make sure the user is authenticated
	if (!Ezcha.client.is_authenticated()):
		printerr("You are not authenticated. Load the authenticate scene first.")
		return
	
	# Load the user's avatar using a EzchaWebTexture resource
	$Center/Panel/VBox/HBox/Avatar.texture.url = Ezcha.client.user.avatar_url
	
	# Display information from the user's profile
	$Center/Panel/VBox/HBox/VBox/Name.text = Ezcha.client.user.name
	$Center/Panel/VBox/HBox/VBox/Title.text = Ezcha.client.user.title
	$Center/Panel/VBox/HBox/VBox/Level.text = "Level %d" % [Ezcha.client.user.level]
	$Center/Panel/VBox/Bio.text = Ezcha.client.user.bio

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://examples/0_authentication/authentication.tscn")
