extends EzchaResponse
class_name EzchaTrophyQueuedResponse
## A response from the API that returns if a trophy grant has been queued.

func _get_type_map() -> Dictionary:
	return {
		"trophy": EzchaTrophyMeta
	}

## Returns true if the grant has been queued.
var queued: bool = false

## The data of the trophy queued to be granted.
var trophy: EzchaTrophyMeta = null
