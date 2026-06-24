extends RefCounted
class_name MarkItBuilder
## The central logic for documentation generation.

enum _Kind {
	METHOD = 6,
	PROPERTY = 7,
	ENUM = 10,
	STATIC_FUNCTION = 12,
	VARIABLE = 13,
	CONSTANT = 14,
	SIGNAL = 24
}

var _tree: SceneTree = null
var _source_path: String = ""
var _docs_version: String = "stable"
var _private_defs: bool = false

func _init(tree: SceneTree, source_path: String, docs_version: String, private_defs: bool) -> void:
	_tree = tree
	_source_path = source_path
	_docs_version = docs_version
	_private_defs = private_defs

func generate() -> String:
	var start_time: float = Time.get_unix_time_from_system()
	
	# Connect to the language server
	print(MarkItPlugin._PRINT_PREFIX + "Connecting to language server...")
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	var host: String = editor_settings.get_setting("network/language_server/remote_host")
	var port: int = editor_settings.get_setting("network/language_server/remote_port")
	var client: MarkItClient = MarkItClient.new()
	if (await client.connect_to_server(_tree, host, port) != OK):
		printerr(
			MarkItPlugin._PRINT_PREFIX +
			"Could not reach the language server at %s:%d" % [host, port]
		)
		return ""
	print(MarkItPlugin._PRINT_PREFIX + "Connected.")
	
	# Initialize the session
	var root_uri: String = _path_to_uri(ProjectSettings.globalize_path("res://"))
	await client.request("initialize", {
		"processId": null,
		"rootUri": root_uri,
		"capabilities": {}
	})
	client.notify("initialized", {})
	
	# Locate the classes within the project directory
	print(MarkItPlugin._PRINT_PREFIX + "Locating classes for documentation...")
	var source_global: String = ProjectSettings.globalize_path(_source_path)
	var entries: Array[Dictionary] = []
	var class_names: Array[String] = []
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		if (entry.get("language", "") != "GDScript"): continue
		var global_path: String = ProjectSettings.globalize_path(entry.get("path", ""))
		if (!global_path.begins_with(source_global)): continue
		entries.append(entry)
		class_names.append(entry.get("class", ""))
	if (entries.size() > 1):
		print(MarkItPlugin._PRINT_PREFIX + "Sorting classes...")
		entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			var dir_a: String = a["path"].get_base_dir()
			var dir_b: String = b["path"].get_base_dir()
			var dir_cmp: int = dir_a.filecasecmp_to(dir_b)
			if (dir_cmp != 0): return (dir_cmp < 0)
			return (a["class"].filecasecmp_to(b["class"]) < 0)
		)
	print(MarkItPlugin._PRINT_PREFIX + "%d class(es) located." % [entries.size()])
	
	# Request the symbols for each class
	print(MarkItPlugin._PRINT_PREFIX + "Requesting class symbols...")
	var classes: Array[Dictionary] = []
	for entry: Dictionary in entries:
		var c_name: String = entry.get("class", "")
		var path: String = entry["path"]
		var uri: String = _path_to_uri(ProjectSettings.globalize_path(path))
		var source: String = FileAccess.get_file_as_string(path)
		client.notify("textDocument/didOpen", {
			"textDocument": {
				"uri": uri,
				"languageId": "gdscript",
				"version": 1,
				"text": source
			}
		})
		var result: Variant = await client.request(
			"textDocument/documentSymbol", { "textDocument": { "uri": uri } }
		)
		if (result is not Array || (result as Array).is_empty()): continue
		classes.append(_build_class_data(entry, (result as Array)[0], source))
		print(MarkItPlugin._PRINT_PREFIX + "Requested symbols for class %s." % [c_name])
	print(MarkItPlugin._PRINT_PREFIX + "%d class(es) requested." % [classes.size()])
	
	client.close()
	var markdown: String = MarkItMarkdown.new(class_names, _docs_version, _private_defs)\
		.generate(classes)
	var elapsed_time: float = Time.get_unix_time_from_system() - start_time
	print(
		MarkItPlugin._PRINT_PREFIX +
		"Finished generating documentation for %d class(es). Elapsed time: %.2f second(s)." %
		[classes.size(), elapsed_time]
	)
	return markdown

func _path_to_uri(absolute_path: String) -> String:
	return "file:///" + absolute_path.replace("\\", "/").trim_prefix("/")

func _build_class_data(entry: Dictionary, root: Dictionary, source: String) -> Dictionary[String, Variant]:
	var lines: PackedStringArray = source.replace("\r\n", "\n").split("\n")
	# Split the class doc comment into brief and description
	var documentation: String = root.get("documentation", "")
	var brief: String = documentation.strip_edges()
	var description: String = ""
	var split_index: int = documentation.find("\n\n")
	if (split_index != -1):
		brief = documentation.substr(0, split_index).strip_edges()
		description = documentation.substr(split_index + 2).strip_edges()
	
	var data: Dictionary[String, Variant] = {
		"name": entry.get("class", ""),
		"extends": entry.get("base", ""),
		"deprecated": root.get("deprecated", false),
		"brief": brief,
		"description": description,
		"properties": [] as Array[Dictionary],
		"constants": [] as Array[Dictionary],
		"methods": [] as Array[Dictionary],
		"static_functions": [] as Array[Dictionary],
		"signals": [] as Array[Dictionary],
		"enums": [] as Array[Dictionary]
	}
	
	for child: Dictionary in root.get("children", []):
		match int(child.get("kind", 0)):
			_Kind.PROPERTY, _Kind.VARIABLE:
				_resolve_initializer(child, lines)
				data["properties"].append(child)
			_Kind.CONSTANT: data["constants"].append(child)
			_Kind.METHOD: data["methods"].append(child)
			_Kind.STATIC_FUNCTION: data["static_functions"].append(child)
			_Kind.SIGNAL: data["signals"].append(child)
			_Kind.ENUM: data["enums"].append(child)
	return data

func _resolve_initializer(symbol: Dictionary, lines: PackedStringArray) -> void:
	var detail: String = symbol.get("detail", "")
	if (detail.contains(" = ")): return
	var initializer: String = _extract_initializer(symbol, lines)
	if (initializer.is_empty()): return
	symbol["detail"] = detail + " = " + initializer

func _extract_initializer(symbol: Dictionary, lines: PackedStringArray) -> String:
	var symbol_range: Dictionary = symbol.get("range", {})
	if (symbol_range.is_empty()): return ""
	var start_line: int = symbol_range["start"]["line"]
	var end_line: int = symbol_range["end"]["line"]
	if (start_line < 0 || end_line >= lines.size()): return ""
	var declaration: String = ""
	for idx: int in range(start_line, end_line + 1): declaration += lines[idx] + " "
	var assignment: int = _find_assignment(declaration)
	if (assignment == -1): return ""
	return declaration.substr(assignment + 1).strip_edges()

func _find_assignment(text: String) -> int:
	var in_string: bool = false
	var quote: String = ""
	for idx: int in text.length():
		var c: String = text[idx]
		if (in_string):
			if (c == quote): in_string = false
			continue
		if (c == "\"" || c == "'"):
			in_string = true
			quote = c
			continue
		if (c != "="): continue
		var prev: String = text[idx - 1] if idx > 0 else ""
		var next: String = text[idx + 1] if idx < text.length() - 1 else ""
		if (next == "=" || prev in ["=", "<", ">", "!"]): continue
		return idx
	return -1