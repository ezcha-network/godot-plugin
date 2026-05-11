extends EzchaPaginatedResponse
class_name EzchaLeaderboardEntryListResponse
## A response from the API containing a paginated list of leaderboards.

func _get_array_type_map() -> Dictionary:
	return {
		"entries": EzchaLeaderboardEntry
	}

## The list of leaderboards returned by the API request.
var entries: Array[EzchaLeaderboardEntry] = []
