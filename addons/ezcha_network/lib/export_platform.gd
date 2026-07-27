extends EditorExportPlatformExtension

const _LOGO_PATH: String = "res://addons/ezcha_network/assets/export_logo.png"

const _PRESETS_FILE: String = "res://export_presets.cfg"
const _PRESETS_BACKUP_FILE: String = "res://.backup.export_presets.cfg"

const _TEMP_PRESET_NAME: String = "_ezcha_web_temp"

const _EXPORT_TARGETS: PackedStringArray = ["beta", "live"]
const _EXPORT_TARGETS_FRIENDLY: PackedStringArray = ["Beta", "Live"]

const _FEATURE_EXCLUDE_API_KEY: String = "ezcha_exclude_api_key"
const _FEATURE_EXCLUDE_SIGNING_KEY: String = "ezcha_exclude_signing_key"

const _WEB_OPTIONS: PackedStringArray = [
	"custom_template/release",
	"variant/extensions_support",
	"variant/thread_support",
	"vram_texture_compression/for_desktop",
	"vram_texture_compression/for_mobile",
	"html/export_icon",
	"html/custom_html_shell",
	"html/head_include",
	"html/canvas_resize_policy",
	"html/focus_canvas_on_start",
	"html/experimental_virtual_keyboard",
	"threads/emscripten_pool_size",
	"threads/godot_pool_size"
]

const _PRESET_SAVE_DEBOUNCE_MS: int = 1000

const _BUNDLE_CHUNK: int = 1048576
const _FRAME_BUDGET_MS: int = 16

const _PROCESS_POLL_INTERVAL_MS: int = 5000
const _PROCESS_TIMEOUT_MS: int = 600000

class _StateResponse extends EzchaResponse:
	var processing: bool = false

class _UploadResponse extends EzchaResponse:
	var preview_url: String = ""

var _plugin: EzchaPlugin = null

var _running: bool = false
var _build_start: float = 0.0
var _bundle_done: int = 0
var _frame_start: int = 0

# Lifecycle

func _init(plugin: EzchaPlugin) -> void:
	_plugin = plugin

# Export platform

func _cleanup() -> void:
	pass

func _get_name() -> String:
	return "Ezcha Network"

func _get_os_name() -> String:
	return "Web"

func _get_logo() -> Texture2D:
	return load(_LOGO_PATH)

func _get_binary_extensions(_preset: EditorExportPreset) -> PackedStringArray:
	return PackedStringArray(["zip"])

func _get_platform_features() -> PackedStringArray:
	return PackedStringArray(["web"])

func _get_preset_features(_preset: EditorExportPreset) -> PackedStringArray:
	return PackedStringArray(["web"])

func _has_valid_project_configuration(_preset: EditorExportPreset) -> bool:
	return true

func _has_valid_export_configuration(preset: EditorExportPreset, _debug: bool) -> bool:
	set_config_missing_templates(false)
	var errors: PackedStringArray = []
	var ezcha: EzchaSingleton = EzchaSingleton._get_instance()
	if (ezcha == null):
		errors.append("The Ezcha Network plugin is not enabled.")
	else:
		var game_id: String = ezcha.get_game_id()
		if (game_id.strip_edges().is_empty()):
			errors.append("Game ID is not set.")
	if (EzchaOpts._get_build_key().is_empty()):
		errors.append("Build key is not configured.")
	var required_template: String = _required_web_template(preset)
	if (!_web_template_installed(required_template)):
		errors.append("You must install the \"%s\" export template." % [required_template])
		set_config_missing_templates(true)
	set_config_error("\n".join(errors))
	return errors.is_empty()

func _get_export_options() -> Array[Dictionary]:
	return [
		_make_option(&"ezcha_network/launch", TYPE_BOOL, true),
		_make_option(&"ezcha_network/update_version", TYPE_BOOL, false),
		_make_option(
			&"ezcha_network/target", TYPE_INT, 0, PROPERTY_HINT_ENUM,
			",".join(_EXPORT_TARGETS_FRIENDLY)
		),
		_make_option(
			&"ezcha_network/width", TYPE_INT,
			ProjectSettings.get_setting("display/window/size/viewport_width", 800)
		),
		_make_option(
			&"ezcha_network/height", TYPE_INT,
			ProjectSettings.get_setting("display/window/size/viewport_height", 600)
		),
		_make_option(
			&"ezcha_network/fullscreen_enabled", TYPE_BOOL,
			ProjectSettings.get_setting("display/window/size/resizable", false)
		),
		_make_option(&"ezcha_network/shared_array_buffer", TYPE_BOOL, false),
		_make_option(
			&"custom_template/release", TYPE_STRING, "", PROPERTY_HINT_GLOBAL_FILE, "*.zip"
		),
		_make_option(&"variant/extensions_support", TYPE_BOOL, false),
		_make_option(&"variant/thread_support", TYPE_BOOL, false),
		_make_option(&"vram_texture_compression/for_desktop", TYPE_BOOL, true),
		_make_option(&"vram_texture_compression/for_mobile", TYPE_BOOL, false),
		_make_option(&"html/export_icon", TYPE_BOOL, true),
		_make_option(&"html/custom_html_shell", TYPE_STRING, "", PROPERTY_HINT_FILE, "*.html"),
		_make_option(&"html/head_include", TYPE_STRING, "", PROPERTY_HINT_MULTILINE_TEXT),
		_make_option(
			&"html/canvas_resize_policy", TYPE_INT, 2, PROPERTY_HINT_ENUM, "None,Project,Adaptive"
		),
		_make_option(&"html/focus_canvas_on_start", TYPE_BOOL, true),
		_make_option(&"html/experimental_virtual_keyboard", TYPE_BOOL, false),
		_make_option(&"threads/emscripten_pool_size", TYPE_INT, 8),
		_make_option(&"threads/godot_pool_size", TYPE_INT, 4)
	]

func _export_project(preset: EditorExportPreset, _debug: bool, _path: String, _flags: int) -> Error:
	if (_running):
		printerr(EzchaOpts._PRINT_PREFIX + "An export is already in progress.")
		return ERR_BUSY
	
	# Validate parameters
	var ezcha: EzchaSingleton = EzchaSingleton._get_instance()
	if (ezcha == null):
		printerr(EzchaOpts._PRINT_PREFIX + "The Ezcha Network plugin is not enabled.")
		return ERR_UNCONFIGURED
	var game_id: String = ezcha.get_game_id()
	if (game_id.strip_edges().is_empty()):
		printerr(EzchaOpts._PRINT_PREFIX + "Game ID is not set.")
		return ERR_UNCONFIGURED
	var build_key: String = EzchaOpts._get_build_key()
	if (build_key.is_empty()):
		printerr(EzchaOpts._PRINT_PREFIX + "Build key is not configured.")
		return ERR_UNCONFIGURED
	
	# Check that the required template is installed
	var required_template: String = _required_web_template(preset)
	if (!_web_template_installed(required_template)):
		printerr(EzchaOpts._PRINT_PREFIX + "You must install the \"%s\" web export template." % [required_template])
		return ERR_UNCONFIGURED
	
	# Gather everything the build needs
	var target_idx: int = preset.get_or_env(&"ezcha_network/target", "ezcha_target")
	var web_options: Dictionary[String, Variant] = {}
	for option_name: String in _WEB_OPTIONS:
		web_options[option_name] = preset.get(option_name)
	var build_data: Dictionary[String, Variant] = {
		"launch": preset.get(&"ezcha_network/launch"),
		"update_version": preset.get(&"ezcha_network/update_version"),
		"version": EzchaUtil.get_game_version(),
		"embed_width": clampi(int(preset.get(&"ezcha_network/width")), 128, 1280),
		"embed_height": clampi(int(preset.get(&"ezcha_network/height")), 128, 1280),
		"fullscreen_enabled": preset.get(&"ezcha_network/fullscreen_enabled"),
		"shared_array_buffer": preset.get(&"ezcha_network/shared_array_buffer"),
		"debug": false,
		"game_id": game_id,
		"build_key": build_key,
		"target": _EXPORT_TARGETS[target_idx],
		"project_path": ProjectSettings.globalize_path("res://"),
		"presets_path": ProjectSettings.globalize_path(_PRESETS_FILE),
		"custom_features": _build_custom_features(preset),
		"export_filter": _export_filter_to_string(preset.get_export_filter()),
		"include_filter": preset.get_include_filter(),
		"exclude_filter": preset.get_exclude_filter(),
		"web_options": web_options
	}
	
	_build_start = Time.get_unix_time_from_system()
	_set_running(true)
	_run_pipeline.call_deferred(build_data)
	return OK

func _run(_preset: EditorExportPreset, _device: int, _debug_flags: int) -> Error:
	printerr(EzchaOpts._PRINT_PREFIX + "You cannot one-click deploy to Ezcha Network.")
	return ERR_COMPILATION_FAILED

func _is_running() -> bool:
	return _running

func _shutdown() -> void:
	_set_running(false)

# Helpers

func _make_option(option_name: StringName, type: int, default_value: Variant, hint: int = PROPERTY_HINT_NONE, hint_string: String = "") -> Dictionary[String, Variant]:
	return {
		"name": option_name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string,
		"default_value": default_value
	}

func _web_template_installed(template: String) -> bool:
	if (template.is_empty()): return true
	var version: Dictionary = Engine.get_version_info()
	var version_string: String = "%s.%s.%s.%s" % [
		version["major"], version["minor"], version["patch"], version["status"]
	]
	var data_dir: String = EditorInterface.get_editor_paths().get_data_dir()
	var templates_dir: String = data_dir.path_join("export_templates").path_join(version_string)
	return FileAccess.file_exists(templates_dir.path_join(template))

func _required_web_template(preset: EditorExportPreset) -> String:
	if (!String(preset.get(&"custom_template/release")).strip_edges().is_empty()): return ""
	var name: String = "web"
	if (bool(preset.get(&"variant/extensions_support"))): name += "_dlink"
	if (!bool(preset.get(&"variant/thread_support"))): name += "_nothreads"
	return name + "_release.zip"

func _inject_temp_preset(presets_path: String, build_data: Dictionary[String, Variant], index_path: String) -> Error:
	var config: ConfigFile = ConfigFile.new()
	if (FileAccess.file_exists(presets_path)):
		var err: Error = config.load(presets_path)
		if (err != OK): return err
	
	# Find the next available preset index
	var index: int = 0
	while (config.has_section("preset.%d" % [index])): index += 1
	var section: String = "preset.%d" % [index]
	var options_section: String = "preset.%d.options" % [index]
	
	# Preset header
	config.set_value(section, "name", _TEMP_PRESET_NAME)
	config.set_value(section, "platform", "Web")
	config.set_value(section, "runnable", false)
	config.set_value(section, "dedicated_server", false)
	config.set_value(section, "custom_features", build_data["custom_features"])
	config.set_value(section, "export_filter", build_data["export_filter"])
	config.set_value(section, "include_filter", build_data["include_filter"])
	config.set_value(section, "exclude_filter", build_data["exclude_filter"])
	config.set_value(section, "export_path", index_path)
	config.set_value(section, "patches", PackedStringArray())
	config.set_value(section, "encryption_include_filters", "")
	config.set_value(section, "encryption_exclude_filters", "")
	config.set_value(section, "seed", 0)
	config.set_value(section, "encrypt_pck", false)
	config.set_value(section, "encrypt_directory", false)
	config.set_value(section, "script_export_mode", 2)
	
	# Copy web export options
	var web_options: Dictionary = build_data["web_options"]
	for option_name: String in web_options:
		config.set_value(options_section, option_name, web_options[option_name])
	
	return config.save(presets_path)

func _restore_config_files(had_presets: bool) -> void:
	if (had_presets):
		DirAccess.copy_absolute(_PRESETS_BACKUP_FILE, _PRESETS_FILE)
		DirAccess.remove_absolute(_PRESETS_BACKUP_FILE)

func _build_custom_features(preset: EditorExportPreset) -> String:
	var features: PackedStringArray = []
	for feature: String in preset.get_custom_features().split(",", false):
		var trimmed: String = feature.strip_edges()
		if (trimmed.is_empty() || trimmed == _FEATURE_EXCLUDE_SIGNING_KEY): continue
		if (!features.has(trimmed)): features.append(trimmed)
	if (!features.has(_FEATURE_EXCLUDE_API_KEY)):
		features.append(_FEATURE_EXCLUDE_API_KEY)
	return ",".join(features)

func _export_filter_to_string(filter: EditorExportPreset.ExportFilter) -> String:
	match (filter):
		EditorExportPreset.EXPORT_SELECTED_SCENES: return "scenes"
		EditorExportPreset.EXPORT_SELECTED_RESOURCES: return "resources"
		EditorExportPreset.EXCLUDE_SELECTED_RESOURCES: return "exclude"
		EditorExportPreset.EXPORT_CUSTOMIZED: return "customized"
	return "all_resources"

func _remove_directory_recursive(path: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if (dir == null): return
	dir.list_dir_begin()
	var next: String = dir.get_next()
	while (!next.is_empty()):
		if (next == "." || next == ".."):
			next = dir.get_next()
			continue
		var child: String = path.path_join(next)
		if (dir.current_is_dir()): _remove_directory_recursive(child)
		else: DirAccess.remove_absolute(child)
		next = dir.get_next()
	dir.list_dir_end()
	DirAccess.remove_absolute(path)

# Build pipeline

func _run_pipeline(build_data: Dictionary[String, Variant]) -> void:
	var result: Dictionary[String, Variant] = await _perform_build(build_data)
	if (result.get("result", FAILED) != OK):
		_set_running(false)
		printerr(EzchaOpts._PRINT_PREFIX + "Export failed. Check the output log.")
		return
	
	_report("Processing...", -1.0)
	print(EzchaOpts._PRINT_PREFIX + "Processing...")
	var process_start: float = Time.get_unix_time_from_system()
	await _poll_processing(build_data)
	print(
		EzchaOpts._PRINT_PREFIX + "Finished processing in ~%d second(s)." % [
			Time.get_unix_time_from_system() - process_start
		]
	)
	
	_set_running(false)
	print(
		EzchaOpts._PRINT_PREFIX +
		"Export completed. Total time: %d second(s)." % [
			Time.get_unix_time_from_system() - _build_start
		]
	)
	var preview_url: String = result.get("preview_url", "")
	if (build_data["launch"] && !preview_url.is_empty()): OS.shell_open(preview_url)

func _get_tree() -> SceneTree:
	return (Engine.get_main_loop() as SceneTree)

func _dock_available() -> bool:
	return (is_instance_valid(_plugin) && is_instance_valid(_plugin._dock))

func _set_running(value: bool) -> void:
	_running = value
	if (!_dock_available()): return
	_plugin._dock.toggle_bundle_progress(value)

func _fail(result: int) -> Dictionary[String, Variant]:
	return { "result": result, "preview_url": "" }

func _report(status: String, progress: float) -> void:
	if (!_dock_available()): return
	_plugin._dock.update_bundle_status(status)
	_plugin._dock.update_bundle_progress(progress)

func _perform_build(build_data: Dictionary[String, Variant]) -> Dictionary[String, Variant]:
	_report("Initializing...", -1.0)
	print(EzchaOpts._PRINT_PREFIX + "Initializing...")
	var temp_dir: String = OS.get_temp_dir().path_join("ezcha_build_%d" % [randi()])
	var build_dir: String = temp_dir.path_join("build")
	if (DirAccess.make_dir_recursive_absolute(build_dir) != OK):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to create temp build directory.")
		return _fail(ERR_CANT_CREATE)
	var index_path: String = build_dir.path_join("index.html")
	
	# Back up local presets
	var had_presets: bool = FileAccess.file_exists(_PRESETS_FILE)
	if (had_presets): DirAccess.copy_absolute(_PRESETS_FILE, _PRESETS_BACKUP_FILE)
	
	# Inject our temp preset
	var presets_path: String = build_data["presets_path"]
	if (_inject_temp_preset(presets_path, build_data, index_path) != OK):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to write temporary preset.")
		_restore_config_files(had_presets)
		_remove_directory_recursive(temp_dir)
		return _fail(ERR_FILE_CANT_WRITE)
	await _get_tree().create_timer(_PRESET_SAVE_DEBOUNCE_MS / 1000.0).timeout
	if (_inject_temp_preset(presets_path, build_data, index_path) != OK):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to write temporary preset.")
		_restore_config_files(had_presets)
		_remove_directory_recursive(temp_dir)
		return _fail(ERR_FILE_CANT_WRITE)
	
	# Build the web export using a new instance
	_report("Building...", -1.0)
	print(EzchaOpts._PRINT_PREFIX + "Building...")
	var build_start: float = Time.get_unix_time_from_system()
	var export_flag: String = "--export-release"
	if (build_data["debug"]): export_flag = "--export-debug"
	var args: PackedStringArray = [
		"--headless",
		"--path", build_data["project_path"],
		export_flag, _TEMP_PRESET_NAME, index_path
	]
	var output: Array = []
	
	var exit_code: int = await _run_export(args, output)
	_restore_config_files(had_presets)
	if (exit_code != 0 || !FileAccess.file_exists(index_path)):
		printerr(
			EzchaOpts._PRINT_PREFIX + "Web export failed (exit %d).\n%s" % [
				exit_code, "\n".join(PackedStringArray(output))
			]
		)
		_remove_directory_recursive(temp_dir)
		return _fail(FAILED)
	print(
		EzchaOpts._PRINT_PREFIX + "Finished building in %d second(s)." % [
			Time.get_unix_time_from_system() - build_start
		]
	)
	
	# Bundle the web export
	_report("Bundling...", -1.0)
	print(EzchaOpts._PRINT_PREFIX + "Bundling...")
	var bundle_start: float = Time.get_unix_time_from_system()
	var zip_path: String = temp_dir.path_join("bundle.zip")
	var pack_err: Error = await _bundle_zip(build_dir, zip_path)
	_remove_directory_recursive(build_dir)
	if (pack_err != OK):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to bundle the build.")
		_remove_directory_recursive(temp_dir)
		return _fail(pack_err)
	print(
		EzchaOpts._PRINT_PREFIX + "Finished bundling in %d second(s)." % [
			Time.get_unix_time_from_system() - bundle_start
		]
	)
	
	# Upload
	print(EzchaOpts._PRINT_PREFIX + "Uploading...")
	var upload_start: float = Time.get_unix_time_from_system()
	_report("Uploading...", 0.0)
	var response: _UploadResponse = _upload(build_data, zip_path)
	await response.async()
	_remove_directory_recursive(temp_dir)
	if (!response.is_successful()):
		if (!EzchaOpts._should_print_request_errors()):
			printerr(EzchaOpts._PRINT_PREFIX + "Upload failed. Make sure the build key is valid.")
		return _fail(FAILED)
	print(
		EzchaOpts._PRINT_PREFIX + "Finished uploading in %d second(s)." % [
			Time.get_unix_time_from_system() - upload_start
		]
	)
	return { "result": OK, "preview_url": response.preview_url }

func _run_export(args: PackedStringArray, output: Array) -> int:
	var pipe: Dictionary = OS.execute_with_pipe(OS.get_executable_path(), args, false)
	if (!pipe.has("pid")): return FAILED
	var pid: int = pipe["pid"]
	var stdout: FileAccess = pipe["stdio"]
	var stderr: FileAccess = pipe["stderr"]
	var progress: RegEx = RegEx.new()
	progress.compile("\\[\\s*([0-9]+)%\\s*\\]")
	
	# Read lines as they arrive
	var buffer: String = ""
	var err_buffer: String = ""
	while (OS.is_process_running(pid)):
		buffer += _drain(stdout)
		err_buffer += _drain(stderr)
		var newline: int = buffer.rfind("\n")
		if (newline != -1):
			var lines: String = buffer.substr(0, newline)
			buffer = buffer.substr(newline + 1)
			output.append(lines)
			_report_progress(lines, progress)
		await _get_tree().process_frame
	
	# Drain
	buffer += _drain(stdout)
	if (!buffer.is_empty()): output.append(buffer)
	err_buffer += _drain(stderr)
	if (!err_buffer.is_empty()): output.append(err_buffer)
	
	return OS.get_process_exit_code(pid)

func _report_progress(lines: String, progress: RegEx) -> void:
	var latest: RegExMatch = null
	for result: RegExMatch in progress.search_all(lines): latest = result
	if (latest == null): return
	var percent: int = latest.get_string(1).to_int()
	_report("Building...", percent * 0.01)

func _drain(file: FileAccess) -> String:
	var text: String = ""
	while (true):
		var chunk: PackedByteArray = file.get_buffer(4096)
		if (chunk.is_empty()): break
		text += chunk.get_string_from_utf8()
	return text

# Bundle pipeline

func _bundle_zip(source_dir: String, zip_path: String) -> Error:
	if (FileAccess.file_exists(zip_path)): DirAccess.remove_absolute(zip_path)
	var packer: ZIPPacker = ZIPPacker.new()
	if (packer.open(zip_path) != OK):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to prepare zip file.")
		return ERR_CANT_CREATE
	var total: int = maxi(1, _count_bytes(source_dir))
	_bundle_done = 0
	_frame_start = Time.get_ticks_msec()
	var err: Error = await _bundle_dir_recursive(packer, source_dir, "", total)
	packer.close()
	if (err != OK): DirAccess.remove_absolute(zip_path)
	return err

func _count_bytes(path: String) -> int:
	var dir: DirAccess = DirAccess.open(path)
	if (dir == null): return 0
	var total: int = 0
	dir.list_dir_begin()
	var next: String = dir.get_next()
	while (!next.is_empty()):
		if (next == "." || next == ".."):
			next = dir.get_next()
			continue
		var child: String = path.path_join(next)
		if (dir.current_is_dir()):
			total += _count_bytes(child)
		else:
			var file: FileAccess = FileAccess.open(child, FileAccess.READ)
			if (file != null): total += file.get_length()
		next = dir.get_next()
	dir.list_dir_end()
	return total

func _bundle_file(packer: ZIPPacker, src_path: String, dst_path: String, total: int) -> Error:
	var file: FileAccess = FileAccess.open(src_path, FileAccess.READ)
	if (file == null):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to open the file at \"%s\"" % [src_path])
		return ERR_FILE_CANT_READ
	packer.start_file(dst_path)
	while (file.get_position() < file.get_length()):
		var chunk: PackedByteArray = file.get_buffer(_BUNDLE_CHUNK)
		packer.write_file(chunk)
		_bundle_done += chunk.size()
		_report("Bundling...", float(_bundle_done) / float(total))
		if (Time.get_ticks_msec() - _frame_start >= _FRAME_BUDGET_MS):
			await _get_tree().process_frame
			_frame_start = Time.get_ticks_msec()
	packer.close_file()
	file.close()
	return OK

func _bundle_dir_recursive(packer: ZIPPacker, src_path: String, dst_path: String, total: int) -> Error:
	var dir: DirAccess = DirAccess.open(src_path)
	if (dir == null):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to open the directory at \"%s\"" % [src_path])
		return ERR_FILE_CANT_READ
	if (dir.list_dir_begin() != OK):
		printerr(EzchaOpts._PRINT_PREFIX + "Failed to read directory list at \"%s\"" % [src_path])
		return ERR_FILE_CANT_READ
	var err: Error = OK
	var next: String = dir.get_next()
	while (!next.is_empty()):
		if (next == "." || next == ".."):
			next = dir.get_next()
			continue
		var next_src: String = src_path.path_join(next)
		var next_dst: String = next if dst_path.is_empty() else dst_path.path_join(next)
		if (dir.current_is_dir()):
			err = await _bundle_dir_recursive(packer, next_src, next_dst, total)
			if (err != OK): break
		else:
			err = await _bundle_file(packer, next_src, next_dst, total)
			if (err != OK): break
		next = dir.get_next()
	dir.list_dir_end()
	return err

# Upload pipeline

func _upload(build_data: Dictionary[String, Variant], zip_path: String) -> _UploadResponse:
	var push_version: String =\
		build_data["version"] if (build_data["update_version"] && build_data["target"] == "live")\
		else ""
	return EzchaUploader.new()\
		.set_endpoint("/v1/developer/games/%s/embed/%s/upload" % [
			build_data["game_id"], build_data["target"]
		])\
		.set_timeout(500.0)\
		.set_authentication(build_data["build_key"])\
		.add_file("bundle", "application/zip", zip_path)\
		.add_query_parameter("width", build_data["embed_width"])\
		.add_query_parameter("height", build_data["embed_height"])\
		.add_query_parameter("fullscreen_enabled", build_data["fullscreen_enabled"])\
		.add_query_parameter("shared_array_buffer", build_data["shared_array_buffer"])\
		.add_query_parameter("version", push_version)\
		.add_progress_callback(_on_upload_progress)\
		.set_response_object(_UploadResponse.new())\
		.start()

func _on_upload_progress(fraction: float) -> void:
	_report("Uploading...", fraction)

func _poll_processing(build_data: Dictionary[String, Variant]) -> void:
	var deadline: int = Time.get_ticks_msec() + _PROCESS_TIMEOUT_MS
	while (Time.get_ticks_msec() < deadline):
		await _get_tree().create_timer(_PROCESS_POLL_INTERVAL_MS / 1000.0).timeout
		var processing: Variant = await _request_processing_state(build_data)
		if (processing == false): return
	printerr(EzchaOpts._PRINT_PREFIX + "Timed out waiting for the bundle to finish processing.")

func _request_processing_state(build_data: Dictionary[String, Variant]) -> Variant:
	var endpoint: String = "/v1/developer/games/%s/embed/%s/state" % [
		build_data["game_id"], build_data["target"]
	]
	var state: _StateResponse = await EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint(endpoint)\
		.set_authentication(build_data["build_key"])\
		.set_response_object(_StateResponse.new())\
		.fetch().async()
	if (!state.is_successful()): return null
	return state.processing
