extends EzchaDto
class_name EzchaLeaderboard

## The leaderboard's unique identifier.
var id: String = ""

## The display name of the leaderboard.
var name: String = ""

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
