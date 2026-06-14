extends EzchaAPI
class_name EzchaSessionsAPI
## A wrapper for the sessions section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Validates a session token and returns user information related to the current game.
func post_validation(session_token: String = "", game_id: String = "") -> EzchaSessionValidationResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/sessions/validate")\
		.set_authentication(session_token)\
		.set_response_object(EzchaSessionValidationResponse.new())\
		.add_body_data("game_id", game_id)\
		.fetch()
