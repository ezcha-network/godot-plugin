extends EzchaAPI
class_name EzchaTrophiesAPI
## A wrapper for the trophies section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Grant a trophy from a game client using a session token.
## Requires a signing key to be configured.
func post_grant_client(trophy_id: String, session_token: String) -> EzchaTrophyQueuedResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/trophies/grant/client")\
		.set_authentication(session_token)\
		.set_signing_key(_ezcha.get_signing_key())\
		.set_response_object(EzchaTrophyQueuedResponse.new())\
		.add_body_data("trophy_id", trophy_id)\
		.fetch()

## Grant a trophy from a game server using an API key.
## Requires an API key to be configured.
func post_grant_server(trophy_id: String, user_id: String) -> EzchaTrophyQueuedResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/trophies/grant/server")\
		.set_authentication(_ezcha.get_api_key())\
		.set_response_object(EzchaTrophyQueuedResponse.new())\
		.add_body_data("trophy_id", trophy_id)\
		.add_body_data("user_id", user_id)\
		.fetch()
