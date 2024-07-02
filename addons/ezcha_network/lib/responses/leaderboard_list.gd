extends EzchaResponse
class_name EzchaLeaderboardListResponse
## A response from the API containing a list of leaderboards.

func _get_array_type_map() -> Dictionary:
	return {
		"leaderboards": EzchaLeaderboard
	}

## The list of leaderboards returned by the API request.
var leaderboards: Array[EzchaLeaderboard] = []
