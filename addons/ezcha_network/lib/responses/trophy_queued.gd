extends EzchaResponse
class_name EzchaTrophyQueuedResponse
## A response from the API that returns from a trophy grant.

func _get_type_map() -> Dictionary:
	return {
		"trophy": EzchaTrophyObtained
	}

## Returns true if the grant was successful.
var queued: bool = false

## The data of the granted trophy.
var trophy: EzchaTrophyObtained = null
