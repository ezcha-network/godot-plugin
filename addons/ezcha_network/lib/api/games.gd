extends EzchaAPI
class_name EzchaGamesAPI
## A wrapper for the games section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Requests a game from its ID.
func get_from_id(game_id: String) -> EzchaGameResponse:
	var resp: EzchaGameResponse = EzchaGameResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/games")\
		.set_response_object(resp)\
		.add_query_parameter("game_id", game_id)\
		.fetch()
	return resp

## Requests a game from its slug.
func get_from_slug(game_slug: String) -> EzchaGameResponse:
	var resp: EzchaGameResponse = EzchaGameResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/games")\
		.set_response_object(resp)\
		.add_query_parameter("game_slug", game_slug)\
		.fetch()
	return resp

## Requests several games at once.
func get_many(game_ids: PoolStringArray, game_slugs: PoolStringArray = PoolStringArray()) -> EzchaGameListResponse:
	var resp: EzchaGameListResponse = EzchaGameListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/games")\
		.set_response_object(resp)\
		.add_query_parameter("game_id", game_ids)\
		.add_query_parameter("game_slug", game_slugs)\
		.add_query_parameter("force_list", true)\
		.fetch()
	return resp

## Requests a randomly chosen game.
func get_random(include_elite_exclusives: bool = false) -> EzchaGameResponse:
	var resp: EzchaGameResponse = EzchaGameResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/games/random")\
		.set_response_object(resp)\
		.add_query_parameter("include_exclusives", str(include_elite_exclusives))\
		.fetch()
	return resp

## Requests the current game of the day.
func get_game_of_the_day() -> EzchaGameResponse:
	var resp: EzchaGameResponse = EzchaGameResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/games/gotd")\
		.set_response_object(resp)\
		.fetch()
	return resp

## Requests the trophies belonging to a game.
func get_trophies(game_id: String) -> EzchaTrophyMetaListResponse:
	var resp: EzchaTrophyMetaListResponse = EzchaTrophyMetaListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/games/trophies")\
		.set_response_object(resp)\
		.add_query_parameter("game_id", game_id)\
		.fetch()
	return resp

## Requests the leaderboards belonging to a game.
func get_leaderboards(game_id: String) -> EzchaLeaderboardListResponse:
	var resp: EzchaLeaderboardListResponse = EzchaLeaderboardListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/games/leaderboards")\
		.set_response_object(resp)\
		.add_query_parameter("game_id", game_id)\
		.fetch()
	return resp
