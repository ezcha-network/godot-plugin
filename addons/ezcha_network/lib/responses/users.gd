extends EzchaResponse
class_name EzchaUsersResponse
## A response from the API containing multiple users.

func _get_array_type_map() -> Dictionary:
	return {
		"users": EzchaUser
	}

## The users returned by the API request.
var users: Array[EzchaUser] = []
