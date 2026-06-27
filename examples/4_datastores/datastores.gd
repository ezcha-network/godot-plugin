extends Control

const DATASTORE_KEY: String = "example"

@onready var text_edit: TextEdit = $Center/Panel/VBox/TextEdit
@onready var back: Button = $Center/Panel/VBox/HBox/Back
@onready var save: Button = $Center/Panel/VBox/HBox/Save

func _ready() -> void:
	# Make sure the user is authenticated
	if (!Ezcha.client.is_authenticated()):
		printerr("You are not authenticated. Load the authenticate scene first.")
		return
	
	# Fill the text edit with the datastore value
	text_edit.text = await Ezcha.client.get_datastore(DATASTORE_KEY)
	toggle_lock(false)

func toggle_lock(locked: bool) -> void:
	text_edit.editable = !locked
	for btn: Button in [back, save]: btn.disabled = locked

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://examples/0_authentication/authentication.tscn")

func _on_save_pressed() -> void:
	toggle_lock(true)
	await Ezcha.client.set_datastore(DATASTORE_KEY, text_edit.text)
	toggle_lock(false)
