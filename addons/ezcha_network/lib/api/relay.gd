extends EzchaAPI
class_name EzchaRelayAPI
## A wrapper for the relay section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Returns a list of available relay servers.
func get_servers() -> EzchaRelayServerListResponse:
	var resp: EzchaRelayServerListResponse = EzchaRelayServerListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/relay/servers")\
		.set_response_object(resp)\
		.fetch()
	return resp

## Returns a list of available public lobbies.
func get_lobbies(game_id: String, page: int = 1, version: String = "", game_mode: int = -1, region: String = "", server_id: String = "") -> EzchaPaginatedLobbyListResponse:
	var res: EzchaPaginatedLobbyListResponse = EzchaPaginatedLobbyListResponse.new()
	var req: EzchaRequestBuilder = EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/relay/lobbies")\
		.set_response_object(res)\
		.add_query_parameter("game_id", game_id)\
		.add_query_parameter("page", page)
	if (!version.is_empty()): req.add_query_parameter("version", version)
	if (game_mode > -1): req.add_query_parameter("game_mode", game_mode)
	if (!region.is_empty()): req.add_query_parameter("region", region)
	if (!server_id.is_empty()): req.add_query_parameter("server_id", server_id)
	req.fetch()
	return res

## Resolves a lobby from its join code.
func resolve_lobby(game_id: String, join_code: String) -> EzchaRelayLobbyResponse:
	var res: EzchaRelayLobbyResponse = EzchaRelayLobbyResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/relay/lobbies/resolve")\
		.set_response_object(res)\
		.add_query_parameter("game_id", game_id)\
		.add_query_parameter("join_code", join_code)\
		.fetch()
	return res
