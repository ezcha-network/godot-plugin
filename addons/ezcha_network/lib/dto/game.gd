extends EzchaDto
class_name EzchaGame

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

## The pricing model for the game.
## free, elite_exclusive, select_price_suggested, select_price_minimum, fixed_price
var pricing_model: String = ""

## The price of the game in USD cents.
var price: int = 0

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

## Check if two instances represent the same game.
## Data can vary if requested at different times.
func equals(other: EzchaGame) -> bool:
	return (id == other.id)

## Requests the trophies belonging to this game.
## A session with sufficient permissions can be provided to include unlisted trophies, but is not required.
func get_trophies(session_token: String = "") -> EzchaTrophyListResponse:
	return EzchaSingleton._get_instance().games.get_trophies(id, session_token)

## Requests the leaderboards belonging to this game.
## A session with sufficient permissions can be provided to include unlisted leaderboards, but is not required.
func get_leaderboards(session_token: String = "") -> EzchaLeaderboardListResponse:
	return EzchaSingleton._get_instance().games.get_leaderboards(id, session_token)

## Requests the products belonging to this game.
## A session with sufficient permissions can be provided to include unlisted products, but is not required.
func get_products(session_token: String = "") -> EzchaProductListResponse:
	return EzchaSingleton._get_instance().games.get_products(id, session_token)
