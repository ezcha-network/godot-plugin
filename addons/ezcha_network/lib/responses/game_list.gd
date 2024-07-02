extends EzchaResponse
class_name EzchaGameListResponse
## A response from the API containing a list of games.

func _get_array_type_map() -> Dictionary:
	return {
		"games": EzchaGame
	}

## The list of games returned by the API request.
var games: Array[EzchaGame] = []
