extends EzchaAPI
class_name EzchaRelayAPI
## A wrapper for the relay section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Returns a list of available relay servers.
func get_servers() -> EzchaRelayServerListResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/relay/servers")\
		.set_response_object(EzchaRelayServerListResponse.new())\
		.fetch()

## Returns a list of available public lobbies.
func get_lobbies(game_id: String, page: int = 1, version: String = "", game_mode: int = -1, region: String = "", server_id: String = "") -> EzchaLobbyListResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/relay/lobbies")\
		.set_response_object(EzchaLobbyListResponse.new())\
		.add_query_parameter("game_id", game_id)\
		.add_query_parameter("page", page)\
		.add_query_parameter("version", version)\
		.add_query_parameter("game_mode", game_mode if (game_mode > -1) else null)\
		.add_query_parameter("region", region)\
		.add_query_parameter("server_id", server_id)\
		.fetch()

## Resolves a lobby from its join code.
func resolve_lobby(game_id: String, join_code: String) -> EzchaRelayLobbyResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/relay/lobbies/resolve")\
		.set_response_object(EzchaRelayLobbyResponse.new())\
		.add_query_parameter("game_id", game_id)\
		.add_query_parameter("join_code", join_code)\
		.fetch()
