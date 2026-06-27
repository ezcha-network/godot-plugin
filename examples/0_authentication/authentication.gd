extends Control

# Many features provided by Ezcha Network such as trophies and leaderboards
# require the user to be authenticated. The plugin makes this easy to do.

@onready var auth_message: Label = $Center/AuthMessage
@onready var examples_panel = $Center/Examples
@onready var example_list: ItemList = $Center/Examples/Contents/List
@onready var view_button: Button = $Center/Examples/Contents/View

var example_paths: PackedStringArray = []

func _ready() -> void:
	auth_message.show()
	examples_panel.hide()
	
	# Skip the following logic if the user is already authenticated. This can
	# happen when they return from another example.
	if (Ezcha.client.is_authenticated()):
		show_example_list()
		return
	
	# On web all you need to do is call this function. The plugin  communicates
	# with the website to get a valid session if the user is logged in.
	var authenticated = await Ezcha.client.authenticate()
	
	# We can then check the response to see if the user with successfully
	# authenticated or not.
	if (!authenticated):
		auth_message.text = "Authentication failed."
		return
	
	show_example_list()

func show_example_list() -> void:
	example_paths.clear()
	view_button.disabled = true
	var base_dir: String = "res://examples/"
	var directories: PackedStringArray = DirAccess.get_directories_at(base_dir)
	for dir_idx: int in directories.size():
		var dir_name: String = directories[dir_idx]
		var example_dir: String = base_dir.path_join(dir_name)
		var scene_file: String = "%s.tscn" % [dir_name.split("_", true, 1)[-1]]
		example_paths.append(example_dir.path_join(scene_file))
		example_list.add_item("#%d  %s" % [dir_idx, scene_file])
		example_list.set_item_disabled(dir_idx, dir_idx == 0)
	auth_message.hide()
	examples_panel.show()

func goto_example(index: int) -> void:
	get_tree().change_scene_to_file(example_paths[index])

func _on_examples_item_selected(_index: int) -> void:
	view_button.disabled = false

func _on_examples_item_activated(index: int) -> void:
	goto_example(index)

func _on_view_pressed() -> void:
	var selected: PackedInt32Array = example_list.get_selected_items()
	if (!selected.is_empty()): goto_example(selected[0])
