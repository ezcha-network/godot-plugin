extends EzchaDto
class_name EzchaLeaderboardEntry

func _get_type_map() -> Dictionary:
	return {
		"leaderboard": EzchaLeaderboard,
		"user": EzchaUser
	}

## The entry's current score.
var score: float = 0.0

## The leaderboard that the entry belongs to.
## Not all responses will included this data.
var leaderboard: EzchaLeaderboard = null

## The user that the entry belongs to.
## Not all responses will included this data.
var user: EzchaUser = null

## The timestamp of when this entry was first created.
var created_timestamp: String = ""

## The timestamp of when this entry was last updated.
var last_updated_timestamp: String = ""
