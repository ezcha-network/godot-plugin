extends EzchaPaginatedResponse
class_name EzchaPaginatedNewsListResponse
## A response from the API containing a paginated list of leaderboards.

func _get_array_type_map() -> Dictionary:
	return {
		"posts": EzchaNewsPost
	}

## The list of news posts returned by the API request.
## (EzchaNewsPost)
var posts: Array = []
