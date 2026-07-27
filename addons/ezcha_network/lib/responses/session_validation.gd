extends EzchaResponse
class_name EzchaSessionValidationResponse
## A response from the API containing the information related to a validated session.

## The user associated with the session.
var user: EzchaUser = null

## The trophies that the user has obtained from this game.
var trophies_obtained: Array[EzchaTrophyObtained] = []

## The leaderboard entries the user has for this game.
var leaderboard_entries: Array[EzchaLeaderboardEntry] = []

## The permanent/non-consumable product purchases this user has made.
var products_purchased: Array[EzchaProductPurchase] = []

## The product purchases this user has made which are pending consumption.
var products_unconsumed: Array[EzchaProductPurchase] = []

## If true the user should have access to any available moderation tools.
var moderation_tools: bool = false
