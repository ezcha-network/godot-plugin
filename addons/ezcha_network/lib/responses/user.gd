extends EzchaResponse
class_name EzchaUserResponse
## A response from the API containing a single user.

func _get_type_map() -> Dictionary:
	return {
		"user": EzchaUser
	}

## The user returned by the API request.
var user: EzchaUser = null
