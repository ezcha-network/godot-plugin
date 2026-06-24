@tool
extends EditorPlugin
class_name MarkItPlugin
## A helper plugin to generate markdown documentation for a project's classes.

signal _path_selected(path: String)

enum _Setting {
	PROJECT_PATH = 0,
	EXPORT_PATH = 1,
	INCLUDE_PRIVATE_DEFINITIONS = 2
}

const _SETTINGS_MAP: Array[Dictionary] = [
	{
		"name": "mark_it/config/project_path",
		"value": "res://",
		"hint": PROPERTY_HINT_DIR
	},
	{
		"name": "mark_it/config/export_path",
		"value": "",
		"hint": PROPERTY_HINT_SAVE_FILE,
		"hint_string": "*.md"
	},
	{
		"name": "mark_it/config/include_private_definitions",
		"value": false
	}
]

const _PRINT_PREFIX: String = "[Mark It] "
const _TOOL_NAME: String = "Generate Documentation..."

# Lifecycle

func _disable_plugin() -> void:
	# Clean settings
	for setting: Dictionary in _SETTINGS_MAP:
		if (!ProjectSettings.has_setting(setting["name"])): continue
		ProjectSettings.clear(setting["name"])

func _enter_tree() -> void:
	# Ensure settings exist
	for setting: Dictionary in _SETTINGS_MAP:
		if (!ProjectSettings.has_setting(setting["name"])):
			ProjectSettings.set_setting(setting["name"], setting["value"])
		ProjectSettings.set_initial_value(setting["name"], setting["value"])
		ProjectSettings.add_property_info({
			"name": setting["name"],
			"type": typeof(setting["value"]),
			"hint": setting.get("hint", PROPERTY_HINT_NONE),
			"hint_string": setting.get("hint_string", "")
		})
	
	# Add tool option
	add_tool_menu_item(_TOOL_NAME, _generate)

func _exit_tree() -> void:
	# Clean tool option
	remove_tool_menu_item(_TOOL_NAME)

# Helpers

func _get_setting(idx: int) -> Variant:
	return ProjectSettings.get_setting(_SETTINGS_MAP[idx]["name"], _SETTINGS_MAP[idx]["value"])

func _prompt_path(
	title: String, mode: DisplayServer.FileDialogMode, file_name: String, filters: PackedStringArray
) -> String:
	var callback: Callable = (func(
		status: bool, selected_paths: PackedStringArray, selected_filter_index: int
	) -> void:
		_path_selected.emit("" if selected_paths.is_empty() else selected_paths[0])
	)
	DisplayServer.file_dialog_show(
		title,
		ProjectSettings.globalize_path("res://"),
		file_name,
		false,
		mode,
		filters,
		callback
	)
	return await _path_selected

# Generation

func _generate() -> void:
	# Resolve the source directory
	var project_path: String = _get_setting(_Setting.PROJECT_PATH)
	if (project_path.is_empty()):
		project_path = await _prompt_path(
			"Select source directory",
			DisplayServer.FILE_DIALOG_MODE_OPEN_DIR,
			"",
			PackedStringArray()
		)
	if (project_path.is_empty()):
		printerr(_PRINT_PREFIX + "No project directory selected.")
		return
	
	# Resolve the export path
	var export_path: String = _get_setting(_Setting.EXPORT_PATH)
	if (export_path.is_empty()):
		export_path = await _prompt_path(
			"Documentation export location",
			DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,
			"docs.md",
			["*.md"]
		)
	if (export_path.is_empty()):
		printerr(_PRINT_PREFIX + "No export location selected.")
		return
	
	# Run the pipeline
	var version_info: Dictionary = Engine.get_version_info()
	var docs_version: String = "%d.%d" % [version_info["major"], version_info["minor"]]
	var private_defs: bool = _get_setting(_Setting.INCLUDE_PRIVATE_DEFINITIONS)
	var builder: MarkItBuilder = MarkItBuilder.new(
		get_tree(), project_path, docs_version, private_defs
	)
	var markdown: String = await builder.generate()
	if (markdown.is_empty()): return
	
	# Write the markdown
	var file: FileAccess = FileAccess.open(export_path, FileAccess.WRITE)
	if (file == null):
		printerr(_PRINT_PREFIX + "Failed to open export file at \"%s\"" % [export_path])
		return
	file.store_string(markdown)
	file.close()
	
	# All done!
	var local_path: String = ProjectSettings.localize_path(export_path)
	if (local_path.begins_with("res://")):
		var cached: Resource = ResourceLoader.get_cached_ref(export_path)
		if (cached != null):
			EditorInterface.get_file_system_dock().file_removed.emit(local_path)
			cached.take_over_path("res://.docgen_outdated.md")
		EditorInterface.get_resource_filesystem().update_file(local_path)
		EditorInterface.select_file(local_path)
	print(
		_PRINT_PREFIX +
		"If you appreciate this plugin please consider supporting us at https://ezcha.net/elite :)"
	)