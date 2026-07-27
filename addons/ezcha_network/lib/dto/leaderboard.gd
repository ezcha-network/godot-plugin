extends EzchaDto
class_name EzchaLeaderboard

## The leaderboard's unique identifier.
var id: String = ""

## The display name of the leaderboard.
var name: String = ""

## Indicates if the leaderboard is hidden from public view.
var unlisted: bool = false

## The sort mode of the leaderboard. ("asc" or "desc")
var sorting: String = ""

## The value type the leaderboard represents. (Score, Points, Wins, etc)
var value_type: String = ""

## The prefix to show before the values when displayed.
var value_prefix: String = ""

## The suffix to show after the values when displayed.
var value_suffix: String = ""

## The timestamp of when the leaderboard was created.
var created_timestamp: String = ""

## Check if two instances represent the same leaderboard.
## Data can vary if requested at different times.
func equals(other: EzchaLeaderboard) -> bool:
	return (id == other.id)

## Returns a paginated list of entries for this leaderboard.
## A session token is only required when attempting to access an unlisted leaderboard.
func get_entries(page: int = 1, items_per_page: int = -1, session_token: String = "") -> EzchaLeaderboardEntryListResponse:
	return EzchaSingleton._get_instance().leaderboards.get_entries(id, page, items_per_page, session_token)
