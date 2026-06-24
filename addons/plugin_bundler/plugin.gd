@tool
extends EditorPlugin
## A helper plugin to bundle other plugins for distribution on the Godot Asset Store.

signal _save_path_selected()

enum _Setting {
	PLUGIN_PATH = 0,
	LICENSE_PATH = 1,
	INCLUDE_IMPORT_FILES = 2,
	INCLUDE_UID_FILES = 3,
	COMPRESSION_LEVEL = 4
}

const _SETTINGS_MAP: Array[Dictionary] = [
	{
		"name": "plugin_bundler/config/plugin_path",
		"value": "",
		"hint": PROPERTY_HINT_DIR
	},
	{
		"name": "plugin_bundler/config/license_path",
		"value": "",
		"hint": PROPERTY_HINT_FILE_PATH
	},
	{
		"name": "plugin_bundler/config/include_import_files",
		"value": true
	},
	{
		"name": "plugin_bundler/config/include_uid_files",
		"value": true
	},
	{
		"name": "plugin_bundler/config/compression_level",
		"value": -1,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "-1,9"
	}
]

const _PRINT_PREFIX: String = "[Bundler] "
const _TOOL_NAME: String = "Bundle Plugin..."

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
	add_tool_menu_item(_TOOL_NAME, _bundle)

func _exit_tree() -> void:
	# Clean tool option
	remove_tool_menu_item(_TOOL_NAME)

# Helpers

func _get_setting(idx: int) -> Variant:
	return ProjectSettings.get_setting(_SETTINGS_MAP[idx]["name"], _SETTINGS_MAP[idx]["value"])

func _get_export_path(file_name: String) -> String:
	var callback: Callable = (func(
		status: bool, selected_paths: PackedStringArray, selected_filter_index: int
	) -> void: 
		_save_path_selected.emit("" if selected_paths.is_empty() else selected_paths[0])
	)
	DisplayServer.file_dialog_show(
		"Bundle export location",
		ProjectSettings.globalize_path("res://"),
		file_name,
		false,
		DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,
		["*.zip"],
		callback
	)
	return await _save_path_selected

# Bundle logic

func _bundle_file(
	packer: ZIPPacker, src_path: String, dst_path: String, check_existance: bool
) -> Error:
	# Check if the file exists
	if (check_existance && !FileAccess.file_exists(src_path)):
		printerr(_PRINT_PREFIX + "File does not exist at \"%s\"" % src_path)
		return ERR_FILE_BAD_PATH
	
	# Read the file
	var file: FileAccess = FileAccess.open(src_path, FileAccess.READ)
	if (file == null):
		printerr(_PRINT_PREFIX + "Failed to open the file at \"%s\"" % src_path)
		return ERR_FILE_CANT_READ
	
	# Copy data to zip
	var data: PackedByteArray = file.get_buffer(file.get_length() - 1)
	file.close()
	packer.start_file(dst_path)
	packer.write_file(data)
	packer.close_file()
	return OK

func _bundle_dir_recursive(
	packer: ZIPPacker, src_path: String, dst_path: String,
	check_existance: bool, exclude_ext: PackedStringArray
) -> Error:
	# Check if the directory exists
	if (check_existance && !DirAccess.dir_exists_absolute(src_path)):
		printerr(_PRINT_PREFIX + "Directory does not exist at \"%s\"" % src_path)
		return ERR_FILE_BAD_PATH
	
	# Open the directory
	var dir: DirAccess = DirAccess.open(src_path)
	if (dir == null):
		printerr(_PRINT_PREFIX + "Failed to open the directory at \"%s\"" % src_path)
		return ERR_FILE_CANT_READ
	
	# Prepare directory list
	if (dir.list_dir_begin() != OK):
		printerr(_PRINT_PREFIX + "Failed to read directory list at \"%s\"" % src_path)
		return ERR_FILE_CANT_READ
	var err: Error = OK
	var next: String = dir.get_next()
	
	# Iterate directory list
	print(_PRINT_PREFIX + "Copying directory at \"%s\"" % [src_path])
	while (!next.is_empty()):
		var next_path: String = src_path.path_join(next)
		var next_dst_path: String = dst_path.path_join(next)
		if (dir.current_is_dir()):
			# Copy directory
			err = _bundle_dir_recursive(packer, next_path, next_dst_path, false, exclude_ext)
			if (err != OK): break
		else:
			# Copy file
			if (!exclude_ext.has(next_path.get_extension())):
				err = _bundle_file(packer, next_path, next_dst_path, false)
				if (err != OK): break
		next = dir.get_next()
	
	dir.list_dir_end()
	return err

func _bundle() -> void:
	# Get bundle settings
	var start_time: float = Time.get_unix_time_from_system()
	var plugin_path: String = _get_setting(_Setting.PLUGIN_PATH)
	var license_path: String = _get_setting(_Setting.LICENSE_PATH)
	var include_import_files: bool = _get_setting(_Setting.INCLUDE_IMPORT_FILES)
	var include_uid_files: bool = _get_setting(_Setting.INCLUDE_UID_FILES)
	var compression_level: int = _get_setting(_Setting.COMPRESSION_LEVEL)
	
	# Validate settings
	if (plugin_path.is_empty()):
		printerr(_PRINT_PREFIX + "You must set the plugin path in the project settings.")
		return
	
	# Get plugin info
	var config_path: String = plugin_path.path_join("plugin.cfg")
	if (!FileAccess.file_exists(config_path)):
		printerr(_PRINT_PREFIX + "Plugin config file is missing.")
		return
	var config: ConfigFile = ConfigFile.new()
	if (config.load(config_path) != OK):
		printerr(_PRINT_PREFIX + "Failed to load plugin config file.")
		return
	var plugin_name: String = config.get_value("plugin", "name")
	var plugin_version: String = config.get_value("plugin", "version")
	
	# Prepare zip path
	var export_name: String = (
		"%s-%s.zip" % [plugin_name, plugin_version.replace(".", "-")]
	).to_kebab_case()
	var export_path: String = await _get_export_path(export_name)
	if (export_path.is_empty()): return
	if (FileAccess.file_exists(export_path)): DirAccess.remove_absolute(export_path)
	
	# Prepare zip file
	var packer: ZIPPacker = ZIPPacker.new()
	packer.compression_level = compression_level
	if (packer.open(export_path) != OK):
		printerr(_PRINT_PREFIX + "Failed to prepare zip file.")
		return
	print(_PRINT_PREFIX + "Exporting to \"%s\"" % [export_path])
	
	# Common things
	var root_path: String = plugin_path.trim_prefix("res://")
	var bundle_failed: Callable = (func() -> void:
		packer.close()
		DirAccess.remove_absolute(export_path)
		printerr(_PRINT_PREFIX + "Failed to bundle plugin.")
	)
	
	# Copy license
	if (!license_path.is_empty()):
		if (_bundle_file(packer, license_path, root_path.path_join("LICENSE"), true) != OK):
			return bundle_failed.call()
		print(_PRINT_PREFIX + "Copied license file.")
	
	# Copy plugin directory
	var exclude_ext: PackedStringArray = []
	if (!include_import_files): exclude_ext.append("import")
	if (!include_uid_files): exclude_ext.append("uid")
	var bundle_err: Error = _bundle_dir_recursive(packer, plugin_path, root_path, true, exclude_ext)
	if (bundle_err != OK): return bundle_failed.call()
	
	# All done!
	packer.close()
	OS.shell_show_in_file_manager(export_path)
	var end_time: float = Time.get_unix_time_from_system()
	var elapsed_time: float = end_time - start_time
	print(
		_PRINT_PREFIX +
		"Finished bundling the plugin. Elapsed time: %.2f second(s)." % [elapsed_time]
	)
	print(
		_PRINT_PREFIX +
		"If you appreciate this plugin please consider supporting us at https://ezcha.net/elite :)"
	)