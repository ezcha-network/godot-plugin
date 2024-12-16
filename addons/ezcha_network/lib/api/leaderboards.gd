extends EzchaAPI
class_name EzchaLeaderboardsAPI
## A wrapper for the leaderboards section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## The update mode 
enum UpdateMode {
	SET = 0,
	ADD = 1,
	SUBTRACT = 2
}

var _update_mode_map: PackedStringArray = PackedStringArray(["set", "add", "subtract"])

## Returns a paginated list of entries for a specific leaderboard.
## A session token is only required when attempting to access an unlisted leaderboard.
func get_entries(leaderboard_id: String, page: int = 1, session_token: String = "") -> EzchaPaginatedLeaderboardEntryListResponse:
	var resp: EzchaPaginatedLeaderboardEntryListResponse = EzchaPaginatedLeaderboardEntryListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/leaderboards/entries")\
		.set_authentication(session_token)\
		.set_response_object(resp)\
		.add_query_parameter("leaderboard_id", leaderboard_id)\
		.add_query_parameter("page", page)\
		.fetch()
	return resp

## Updates a score from a game client using a session token.
## Requires a signing key to be configured.
func post_entry_client(leaderboard_id: String, session_token: String, score: float, mode: UpdateMode = UpdateMode.SET) -> EzchaLeaderboardQueuedResponse:
	var resp: EzchaLeaderboardQueuedResponse = EzchaLeaderboardQueuedResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/leaderboards/entries/client")\
		.set_authentication(session_token)\
		.set_signing_key(_ezcha.get_signing_key())\
		.set_response_object(resp)\
		.add_body_data("leaderboard_id", leaderboard_id)\
		.add_body_data("score", score)\
		.add_body_data("mode", _update_mode_map[mode])\
		.fetch()
	return resp

## Updates a score from a game server using an API key.
## Requires an API key to be configured.
func post_entry_server(leaderboard_id: String, user_id: String, score: float, mode: UpdateMode = UpdateMode.SET) -> EzchaLeaderboardQueuedResponse:
	var resp: EzchaLeaderboardQueuedResponse = EzchaLeaderboardQueuedResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/leaderboards/entries/server")\
		.set_authentication(_ezcha.get_api_key())\
		.set_response_object(resp)\
		.add_body_data("leaderboard_id", leaderboard_id)\
		.add_body_data("score", score)\
		.add_body_data("mode", _update_mode_map[mode])\
		.add_body_data("user_id", user_id)\
		.fetch()
	return resp
