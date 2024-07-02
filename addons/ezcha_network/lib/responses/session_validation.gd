extends EzchaResponse
class_name EzchaSessionValidationResponse
## A response from the API containing the information related to a validated session.

func _get_type_map() -> Dictionary:
	return {
		"user": EzchaUser
	}

func _get_array_type_map() -> Dictionary:
	return {
		"trophies_obtained": EzchaTrophyMeta,
		"leaderboard_entries": EzchaLeaderboardEntry
	}

## The user associated with the session.
var user: EzchaUser = null

## The trophies that the user has obtained from this game.
## (EzchaTrophyMeta)
var trophies_obtained: Array = []

## The leaderboard entries the user has for this game.
## (EzchaLeaderboardEntry)
var leaderboard_entries: Array = []

## If true the user should have access to any available moderation tools.
var moderation_tools: bool = false
