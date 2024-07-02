extends EzchaAPI
class_name EzchaSessionsAPI
## A wrapper for the sessions section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Returns a paginated list of news posts based on the criteria provided.
## Category and series are mutually exclusive and cannot be used together.
func post_validation(session_token: String = "", game_id: String = "") -> EzchaSessionValidationResponse:
	var resp: EzchaSessionValidationResponse = EzchaSessionValidationResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/sessions/validate")\
		.set_authentication(session_token)\
		.set_response_object(resp)\
		.add_body_data("game_id", game_id)\
		.fetch()
	return resp
