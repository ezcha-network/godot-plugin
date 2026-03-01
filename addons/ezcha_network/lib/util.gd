extends Object
class_name EzchaUtil
## Common utilities used across the plugin.

## Returns the version as defined in the project settings.
static func get_game_version() -> String:
	return ProjectSettings.get_setting("application/config/version", "N/A")

## Parse a start argument depending on the platform.
## Ezcha Network will pass the following URL query parameters as arguments:
## level, lobby, map, world
static func get_start_argument(key: String) -> String:
	if (OS.get_name() == "Web"):
		var js_result: Variant = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('%s')" % [key])
		if (js_result == null): return ""
		return js_result.strip_edges()
	for arg: String in OS.get_cmdline_user_args():
		var split: PackedStringArray = arg.split("=", false, 1)
		if (split.size() < 2): continue
		if (split[0].to_lower() != key): continue
		return split[1].strip_edges()
	return ""

## Unpacks values from a dictionary to a various object.
static func unpack_data(target: Object, data: Dictionary) -> void:
	var type_map: Dictionary = \
		{} if (!target.has_method(&"_get_type_map")) \
		else target._get_type_map()
	var array_type_map: Dictionary = \
		{} if (!target.has_method(&"_get_array_type_map")) \
		else target._get_array_type_map()
	
	# Set values from data dictionary
	for key: String in data.keys():
		var current_value: Variant = target.get(key)
		if (current_value == null && !type_map.has(key)): continue
		var new_value: Variant = data[key] 
		
		# Array
		if (new_value is Array && array_type_map.has(key)):
			current_value.clear()
			var dto_array: Array = []
			for item in new_value:
				var dto: EzchaDto = array_type_map[key].new()
				unpack_data(dto, item)
				current_value.append(dto)
			continue
		
		# Dictionary
		if (new_value is Dictionary && type_map.has(key)):
			var dto: EzchaDto = type_map[key].new()
			unpack_data(dto, new_value)
			target.set(key, dto)
			continue
		
		# Generic
		target.set(key, new_value)
