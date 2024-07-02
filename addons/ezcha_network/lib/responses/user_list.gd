extends EzchaResponse
class_name EzchaUserListResponse
## A response from the API containing a single game.

func _get_array_type_map() -> Dictionary:
	return {
		"users": EzchaUser
	}

## The users returned by the API request.
var users: Array[EzchaUser] = []
