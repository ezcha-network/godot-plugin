extends EzchaDto
class_name EzchaGame

func _get_type_map() -> Dictionary:
	return {
		"developer": EzchaUser
	}

## The game's unique identifier.
var id: String = ""

## The user-friendly identifier for the game in URLs.
var slug: String = ""

## The display name of the game.
var name: String = ""

## The description for the game.
var description: String = ""

## The version the game is specified to be at. This does not follow any specific format.
var version: String = ""

## If true the game can only be accessed by users who have elite membership.
var elite_exclusive: bool = false

## The developer for the game.
var developer: EzchaUser = null

## The URL the game can be viewed and played at.
var url: String = ""

## The URL for the game's banner image.
## This will be a png file.
var banner_url: String = ""

## The URL for the game's thumbnail image.
## This will be a png file.
var thumbnail_url: String = ""

## The timestamp for when the game was released on Ezcha.
var released_timestamp: String = ""

## The timestamp for when the game was published on other platforms before Ezcha.
## Not all games will have this.
var original_released_timestamp: String = ""
