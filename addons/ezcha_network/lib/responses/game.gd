extends EzchaResponse
class_name EzchaGameResponse
## A response from the API containing a single game.

func _get_type_map() -> Dictionary:
	return {
		"game": EzchaGame
	}

## The game returned by the API request.
var game: EzchaGame = null
