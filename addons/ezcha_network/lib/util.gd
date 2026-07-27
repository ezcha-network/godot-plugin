extends Object
class_name EzchaUtil
## Common utilities used across the plugin.

class _UnpackState extends RefCounted:
	var class_map: Dictionary[StringName, Dictionary] = {}
	var class_cache: Dictionary[StringName, GDScript] = {}
	
	func _init() -> void:
		for cl: Dictionary in ProjectSettings.get_global_class_list():
			class_map[cl["class"]] = cl
	
	func store_script(script: Script) -> void:
		var g_name: StringName = script.get_global_name()
		if (g_name.is_empty()): return
		if (!class_cache.has(g_name)): return
		class_cache[g_name] = script
	
	func resolve_class(cl_name: StringName) -> Variant:
		if (class_cache.has(cl_name)): return class_cache[cl_name].new()
		if (!class_map.has(cl_name)): return null
		var path: String = class_map[cl_name]["path"]
		var scr: Variant = load(path)
		if (scr is GDScript):
			class_cache[cl_name] = scr
			return scr.new()
		return null

## Returns the version as defined in the project settings.
static func get_game_version() -> String:
	return ProjectSettings.get_setting("application/config/version", "N/A")

## Parse a start argument depending on the platform.
## Ezcha Network will pass the following URL query parameters as arguments:
## level, lobby, map, world
static func get_start_argument(key: String) -> String:
	if (OS.get_name() == "Web"):
		var js_result: Variant = JavaScriptBridge.eval(
			"new URLSearchParams(window.location.search).get('%s')" % [key]
		)
		if (js_result == null): return ""
		return js_result.strip_edges()
	for arg: String in OS.get_cmdline_user_args():
		var split: PackedStringArray = arg.split("=", false, 1)
		if (split.size() < 2): continue
		if (split[0].to_lower() != key): continue
		return split[1].strip_edges()
	return ""

## Unpacks values from a dictionary to an object.
static func unpack_data(target: Object, data: Dictionary, state: _UnpackState = null) -> Variant:
	# Get target properties list
	var script: Variant = target.get_script()
	if (script is not Script):
		printerr(EzchaOpts._PRINT_PREFIX + "Unpack target must be a script instance.")
		return
	var property_list: Array[Dictionary] = script.get_script_property_list()
	
	# Create a map of the properties for easier access
	var property_map: Dictionary[String, Dictionary] = {}
	for prop: Dictionary in property_list: property_map[prop["name"]] = prop
	
	# Prepare state
	if (state == null): state = _UnpackState.new()
	
	# Interate keys for unpacking
	for key: String in data.keys():
		# Skip if missing
		if (!property_map.has(key)): continue
		var meta: Dictionary = property_map[key]
		var current_value: Variant = target.get(key)
		var current_type: Variant.Type = typeof(current_value)
		var new_value: Variant = data[key]
		
		# Type checking
		match(meta["type"]):
			TYPE_ARRAY:
				if (current_type != TYPE_ARRAY): continue
				var current_arr: Array = current_value as Array
				var new_arr: Array = new_value as Array
				# Untyped
				if (!current_arr.is_typed()):
					target.set(key, new_arr.duplicate(true))
					continue
				# Detect DTO
				var base_type: Variant.Type = current_arr.get_typed_builtin()
				if (base_type == TYPE_OBJECT):
					var scr: Script = current_arr.get_typed_script()
					if (scr != null):
						state.store_script(scr)
						var obj_arr: Array = current_arr.duplicate(false)
						obj_arr.clear()
						for item: Variant in new_value:
							if (item is not Dictionary): continue
							obj_arr.append(unpack_data(scr.new(), item, state))
						target.set(key, obj_arr)
					continue
				# Type check
				var copy_arr: Array[Variant] = []
				for item: Variant in new_arr:
					if (typeof(item) == base_type): copy_arr.append(item)
				target.set(key, copy_arr)
			
			TYPE_DICTIONARY:
				if (current_type != TYPE_DICTIONARY): continue
				var current_dict: Dictionary = current_value as Dictionary
				var new_dict: Dictionary = new_value as Dictionary
				# Untyped
				if (!current_dict.is_typed_value()):
					target.set(key, new_dict.duplicate(true))
					return
				# Detect DTO
				var base_type: Variant.Type = current_dict.get_typed_value_builtin()
				if (base_type == TYPE_OBJECT):
					var scr: Script = current_dict.get_typed_value_script()
					if (scr != null):
						state.store_script(scr)
						var obj_dict: Dictionary = current_dict.duplicate(false)
						obj_dict.clear()
						for n_key: Variant in new_dict.keys():
							var n_val: Variant = new_dict[n_key]
							if (n_val is not Dictionary): continue
							obj_dict[n_key] = unpack_data(scr.new(), n_val, state)
						target.set(key, obj_dict)
					continue
				# Type check
				var copy_dict: Dictionary = current_dict.duplicate(false)
				copy_dict.clear()
				for c_key: Variant in new_dict.keys():
					var c_val: Variant = new_dict[c_key]
					if (typeof(c_val) == base_type): copy_dict[c_key] = c_val
				target.set(key, copy_dict)
			
			TYPE_NIL, TYPE_OBJECT:
				# Detect DTO
				if (current_type != TYPE_NIL && current_type != TYPE_OBJECT): continue
				var cl_name: StringName = meta["class_name"]
				if (cl_name.is_empty()): continue
				var obj: Variant = state.resolve_class(cl_name)
				if (obj == null): continue
				target.set(key, unpack_data(obj, new_value, state))
			
			_:
				# Primitives
				target.set(key, new_value)
	
	return target
