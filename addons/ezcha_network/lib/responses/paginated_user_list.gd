extends EzchaPaginatedResponse
class_name EzchaPaginatedUserListResponse
## A response from the API containing a paginated list of users.

func _get_array_type_map() -> Dictionary:
	return {
		"users": EzchaUser
	}

## The list of users returned by the API request.
var users: Array[EzchaUser] = []
