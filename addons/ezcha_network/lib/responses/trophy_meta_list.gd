extends EzchaResponse
class_name EzchaTrophyMetaListResponse
## A response from the API containing a list of trophies.

func _get_array_type_map() -> Dictionary:
	return {
		"trophies": EzchaTrophyMeta
	}

## The list of trophies returned by the API request.
var trophies: Array[EzchaTrophyMeta] = []
