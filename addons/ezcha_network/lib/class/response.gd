extends RefCounted
class_name EzchaResponse
## The base class for handling Ezcha Network API responses.

## Emitted once the response has been recieved and processed.
signal recieved()

var _pending: bool = true
var _status_code: int = -1
var _error_msg: String = ""

## Returns if the response is okay and is not an error.
func is_successful() -> bool:
	return (_status_code >= 200 && _status_code < 300)

## Returns the status code.
func get_status() -> int:
	return _status_code

## Returns the error message if available.
func get_error() -> String:
	return _error_msg

## Returns if the response is pending or not.
func is_pending() -> bool:
	return _pending

func _get_type_map() -> Dictionary:
	return {}

func _get_array_type_map() -> Dictionary:
	return {}

func _unpack_data(data: Dictionary, target: Object = self) -> void:
	var type_map: Dictionary = target._get_type_map()
	var array_type_map: Dictionary = target._get_array_type_map()
	
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
				_unpack_data(item, dto)
				current_value.append(dto)
			continue
		
		# Dictionary
		if (new_value is Dictionary && type_map.has(key)):
			var dto: EzchaDto = type_map[key].new()
			_unpack_data(new_value, dto)
			target.set(key, dto)
			continue
		
		# Generic
		target.set(key, new_value)
