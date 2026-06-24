extends RefCounted
class_name MarkItMarkdown
## Generates markdown documentation from language server information.

var _class_names: Array[String] = []
var _docs_version: String = "stable"
var _private_defs: bool = false
var _inheritors: Dictionary[String, Array] = {}

func _init(class_names: Array[String], docs_version: String, private_defs: bool) -> void:
	_class_names = class_names
	_docs_version = docs_version
	_private_defs = private_defs

func generate(classes: Array[Dictionary]) -> String:
	print(MarkItPlugin._PRINT_PREFIX + "Generating class index...")
	var md: String = "# Class Index\n"
	for class_data: Dictionary in classes:
		md += "\n* [%s](#%s)" % [class_data["name"], class_data["name"]]
	print(MarkItPlugin._PRINT_PREFIX + "Finished index.")
	_inheritors = {}
	for class_data: Dictionary in classes:
		var base: String = class_data["extends"]
		if (base.is_empty() || !_class_names.has(base)): continue
		if (!_inheritors.has(base)): _inheritors[base] = [] as Array[String]
		_inheritors[base].append(class_data["name"])
	for base: String in _inheritors:
		_inheritors[base].sort()
	print(MarkItPlugin._PRINT_PREFIX + "Generating class documentation...")
	md += "\n\n# Class Documentation"
	for class_data: Dictionary in classes:
		md += _generate_class(class_data)
		print(MarkItPlugin._PRINT_PREFIX + "Generated documentation for %s." % class_data["name"])
	md += "\n"
	return md

func _generate_class(class_data: Dictionary) -> String:
	var name: String = class_data["name"]
	var md: String = "\n\n<a name=\"%s\"></a>\n## %s%s" % [name, name, _deprecated_tag(class_data)]
	
	var base: String = class_data["extends"]
	if (!base.is_empty()):
		var base_url: String = _get_url(base)
		md += ("\n\n**Inherits:** [%s](%s)" % [base, base_url]) \
			if !base_url.is_empty() else ("\n\n**Inherits:** " + base)
	
	var children: Array = _inheritors.get(name, [])
	if (!children.is_empty()):
		var links: Array[String] = []
		for child_name: String in children:
			links.append("[%s](#%s)" % [child_name, child_name])
		md += "\n\n**Inherited By:** " + ", ".join(links)
	
	var brief: String = class_data["brief"]
	if (!brief.is_empty()): md += "\n\n" + brief
	
	var description: String = class_data["description"]
	if (!description.is_empty()): md += "\n\n### Description\n\n" + description
	
	md += _generate_properties(name, class_data["properties"])
	md += _generate_methods(name, class_data["methods"], class_data["static_functions"])
	md += _generate_signals(class_data["signals"])
	md += _generate_enums(class_data["enums"])
	md += _generate_constants(name, class_data["constants"])
	md += _generate_property_descriptions(name, class_data["properties"])
	md += _generate_method_descriptions(name, class_data["methods"], class_data["static_functions"])
	md += _generate_constant_descriptions(name, class_data["constants"])
	return md

func _generate_properties(cls: String, properties: Array[Dictionary]) -> String:
	properties = _filter_private(properties)
	if (properties.is_empty()): return ""
	var md: String = "\n\n### Properties\n\n|Type|Name|Default|\n|-|-|-|"
	for symbol: Dictionary in properties:
		var info: Dictionary[String, Variant] = _parse_member_detail(symbol.get("detail", ""))
		var name_cell: String = info["name"]
		if (_has_documentation(symbol)):
			name_cell = "[%s](#%s-property-%s)" % [info["name"], cls, info["name"]]
		name_cell += _deprecated_tag(symbol)
		md += "\n|%s|%s|%s|" % [_format_type(info["type"]), name_cell, info["value"]]
	return md

func _generate_methods(cls: String, methods: Array[Dictionary], static_functions: Array[Dictionary]) -> String:
	methods = _filter_private(methods)
	static_functions = _filter_private(static_functions)
	if (methods.is_empty() && static_functions.is_empty()): return ""
	var md: String = "\n\n### Methods\n\n|Returns|Name|\n|-|-|"
	md += _method_rows(cls, methods, false)
	md += _method_rows(cls, static_functions, true)
	return md

func _method_rows(cls: String, methods: Array[Dictionary], is_static: bool) -> String:
	var md: String = ""
	for symbol: Dictionary in methods:
		var info: Dictionary[String, Variant] = _parse_method_detail(symbol.get("detail", ""))
		var name_cell: String = info["name"]
		if (_has_documentation(symbol)):
			name_cell = "[%s](#%s-method-%s)" % [info["name"], cls, info["name"]]
		var qualifier: String = " *static*" if is_static else ""
		md += "\n|%s|%s%s%s%s|" % [
			_format_type(info["return"]),
			name_cell,
			_format_arguments(info["args"]),
			qualifier,
			_deprecated_tag(symbol)
		]
	return md

func _generate_signals(signals: Array[Dictionary]) -> String:
	signals = _filter_private(signals)
	if (signals.is_empty()): return ""
	var md: String = "\n\n### Signals"
	for symbol: Dictionary in signals:
		var name: String = symbol.get("name", "")
		var args: Array[Dictionary] = _parse_signal_children(symbol.get("children", []))
		md += "\n\n**%s**%s%s" % [name, _format_arguments(args), _deprecated_tag(symbol)]
		md += "\n\n" + symbol.get("documentation", "")
	return md

func _generate_enums(enums: Array[Dictionary]) -> String:
	enums = _filter_private(enums)
	if (enums.is_empty()): return ""
	var md: String = "\n\n### Enumerations"
	for symbol: Dictionary in enums:
		var enum_name: String = symbol.get("name", "")
		md += "\n\nenum **%s**:\n" % [enum_name]
		for child: Dictionary in symbol.get("children", []):
			var value_info: Dictionary[String, Variant] = \
			_parse_enum_value_detail(child.get("detail", ""), child.get("name", ""))
			md += "\n* %s **%s** = %s" % [enum_name, value_info["name"], value_info["value"]]
	return md

func _generate_constants(cls: String, constants: Array[Dictionary]) -> String:
	constants = _filter_private(constants)
	if (constants.is_empty()): return ""
	var md: String = "\n\n### Constants\n\n|Type|Name|Value|\n|-|-|-|"
	for symbol: Dictionary in constants:
		var info: Dictionary[String, Variant] = _parse_member_detail(symbol.get("detail", ""))
		var name_cell: String = info["name"]
		if (_has_documentation(symbol)):
			name_cell = "[%s](#%s-constant-%s)" % [info["name"], cls, info["name"]]
		name_cell += _deprecated_tag(symbol)
		md += "\n|%s|%s|%s|" % [_format_type(info["type"]), name_cell, info["value"]]
	return md

func _generate_property_descriptions(cls: String, properties: Array[Dictionary]) -> String:
	var documented: Array[Dictionary] = _filter_documented(properties)
	if (documented.is_empty()): return ""
	var md: String = "\n\n### Property Descriptions"
	for symbol: Dictionary in documented:
		var info: Dictionary[String, Variant] = _parse_member_detail(symbol.get("detail", ""))
		md += "\n\n<a name=\"%s-property-%s\"></a>" % [cls, info["name"]]
		md += "\n%s **%s**%s" % [_format_type(info["type"]), info["name"], _deprecated_tag(symbol)]
		if (!String(info["value"]).is_empty()): md += " = " + info["value"]
		md += "\n\n" + symbol.get("documentation", "")
	return md

func _generate_method_descriptions(cls: String, methods: Array[Dictionary], static_functions: Array[Dictionary]) -> String:
	var documented: Array[Dictionary] = _filter_documented(methods)
	documented.append_array(_filter_documented(static_functions))
	if (documented.is_empty()): return ""
	var md: String = "\n\n### Method Descriptions"
	for symbol: Dictionary in documented:
		var info: Dictionary[String, Variant] = _parse_method_detail(symbol.get("detail", ""))
		md += "\n\n<a name=\"%s-method-%s\"></a>" % [cls, info["name"]]
		md += "\n%s **%s**%s%s" % [
			_format_type(info["return"]), info["name"], _format_arguments(info["args"]),
			_deprecated_tag(symbol)
		]
		md += "\n\n" + symbol.get("documentation", "")
	return md

func _generate_constant_descriptions(cls: String, constants: Array[Dictionary]) -> String:
	var documented: Array[Dictionary] = _filter_documented(constants)
	if (documented.is_empty()): return ""
	var md: String = "\n\n### Constant Descriptions"
	for symbol: Dictionary in documented:
		var info: Dictionary[String, Variant] = _parse_member_detail(symbol.get("detail", ""))
		md += "\n\n<a name=\"%s-constant-%s\"></a>" % [cls, info["name"]]
		md += "\n%s **%s**%s" % [_format_type(info["type"]), info["name"], _deprecated_tag(symbol)]
		if (!String(info["value"]).is_empty()):
			md += " = " + info["value"]
		md += "\n\n" + symbol.get("documentation", "")
	return md

func _filter_private(data: Array[Dictionary]) -> Array[Dictionary]:
	if (_private_defs): return data
	return data.filter(func(e: Dictionary): return !e["name"].begins_with("_"))

func _filter_documented(symbols: Array[Dictionary]) -> Array[Dictionary]:
	return symbols.filter(func(e: Dictionary):
		return (_private_defs || !e["name"].begins_with("_")) && _has_documentation(e)
	)

func _has_documentation(symbol: Dictionary) -> bool:
	return (!String(symbol.get("documentation", "")).strip_edges().is_empty())

func _deprecated_tag(symbol: Dictionary) -> String:
	return " **(deprecated)**" if symbol.get("deprecated", false) else ""

func _format_type(type: String) -> String:
	if (type.is_empty()): type = "Variant"
	var subtype: String = _array_subtype(type)
	if (!subtype.is_empty()):
		var array_url: String = _get_builtin_url("array")
		var subtype_url: String = _get_url(subtype)
		if (!subtype_url.is_empty()):
			return "[Array](%s)[[%s](%s)]" % [array_url, subtype, subtype_url]
		return "[Array](%s)[%s]" % [array_url, subtype]
	var type_url: String = _get_url(type)
	if (!type_url.is_empty()): return "[%s](%s)" % [type, type_url]
	return type

func _format_arguments(args: Array[Dictionary]) -> String:
	if (args.is_empty()): return "()"
	var parts: Array[String] = []
	for arg: Dictionary in args:
		var part: String = ""
		var type: String = arg.get("type", "")
		if (!type.is_empty()):
			var type_url: String = _get_url(type)
			part += ("[%s](%s) " % [type, type_url]) if !type_url.is_empty() else (type + " ")
		part += arg["name"]
		var value: String = arg.get("value", "")
		if (!value.is_empty()): part += "=" + value
		parts.append(part)
	return "(%s)" % [", ".join(parts)]

func _get_url(type: String) -> String:
	var base: String = type.split(".")[0]
	if (_class_names.has(base)): return "#" + base
	return _get_builtin_url(base)

func _get_builtin_url(type: String) -> String:
	if (type.to_lower() == "void"): return ""
	return "https://docs.godotengine.org/en/%s/classes/class_%s.html" % [
		_docs_version, type.to_lower()
	]

func _array_subtype(type: String) -> String:
	if (!type.begins_with("Array[")): return ""
	var open: int = type.find("[")
	var close: int = type.rfind("]")
	if (close <= open): return ""
	return type.substr(open + 1, close - open - 1)

func _parse_member_detail(detail: String) -> Dictionary[String, Variant]:
	var working: String = detail
	for prefix: String in ["@export ", "static ", "var ", "const "]:
		working = working.trim_prefix(prefix)
	var result: Dictionary[String, Variant] = _parse_typed_name(working)
	if (String(result["value"]).is_empty()):
		var type: String = result["type"]
		if (type.begins_with("Array")): result["value"] = "[]"
		elif (type.begins_with("Dictionary")): result["value"] = "{}"
		elif (_defaults_to_null(type)): result["value"] = "null"
	return result

func _defaults_to_null(type: String) -> bool:
	return (
		type.is_empty() || type == "Variant" ||
		_class_names.has(type) || ClassDB.class_exists(type)
	)

func _parse_method_detail(detail: String) -> Dictionary[String, Variant]:
	var working: String = detail.trim_prefix("func ")
	var name: String = working
	var return_type: String = ""
	var args: Array[Dictionary] = []
	
	var arrow: int = working.rfind(" -> ")
	if (arrow != -1):
		return_type = working.substr(arrow + 4).strip_edges()
		working = working.substr(0, arrow)
	
	var paren: int = working.find("(")
	if (paren != -1):
		name = working.substr(0, paren).strip_edges()
		var args_str: String = working.substr(paren + 1)
		var close: int = args_str.rfind(")")
		if (close != -1):
			args_str = args_str.substr(0, close)
		args = _parse_arguments(args_str)
	else:
		name = working.strip_edges()
	return { "name": name, "return": return_type, "args": args }

func _parse_signal_children(children: Array) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for child: Dictionary in children:
		result.append(_parse_typed_name(child.get("detail", "").trim_prefix("var ")))
	return result

func _parse_enum_value_detail(detail: String, fallback_name: String) -> Dictionary[String, Variant]:
	var eq: int = detail.find(" = ")
	if (eq == -1): return { "name": fallback_name, "value": "" }
	return {
		"name": detail.substr(0, eq).strip_edges(),
		"value": detail.substr(eq + 3).strip_edges()
	}

func _parse_arguments(args_str: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var trimmed: String = args_str.strip_edges()
	if (trimmed.is_empty()): return result
	for part: String in _split_top_level(trimmed):
		result.append(_parse_typed_name(part.strip_edges()))
	return result

func _parse_typed_name(text: String) -> Dictionary[String, Variant]:
	var working: String = text
	var type: String = ""
	var value: String = ""
	var eq: int = working.find(" = ")
	if (eq != -1):
		value = working.substr(eq + 3).strip_edges()
		working = working.substr(0, eq)
	var colon: int = working.find(":")
	if (colon != -1):
		type = working.substr(colon + 1).strip_edges()
		working = working.substr(0, colon)
	return { "name": working.strip_edges(), "type": type, "value": value }

func _split_top_level(text: String) -> Array[String]:
	var parts: Array[String] = []
	var depth: int = 0
	var in_string: bool = false
	var start: int = 0
	for idx: int in text.length():
		var c: String = text[idx]
		match c:
			"\"":
				in_string = !in_string
			"(", "[", "{":
				if (!in_string): depth += 1
			")", "]", "}":
				if (!in_string): depth -= 1
			",":
				if (!in_string && depth == 0):
					parts.append(text.substr(start, idx - start))
					start = idx + 1
	parts.append(text.substr(start))
	return parts