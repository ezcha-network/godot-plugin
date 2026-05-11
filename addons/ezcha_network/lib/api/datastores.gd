extends EzchaAPI
class_name EzchaDatastoresAPI
## A wrapper for the datastores section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Requests the value of a client-side datastore from its key.
func get_client(key: String, session_token: String) -> EzchaDatastoreValueResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/datastores/client")\
		.set_authentication(session_token)\
		.set_response_object(EzchaDatastoreValueResponse.new())\
		.add_query_parameter("key", key)\
		.fetch()

## Updates the value of a client-side datastore by its key.
func post_client(key: String, value: String, session_token: String) -> EzchaResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/datastores/client")\
		.set_authentication(session_token)\
		.add_body_data("key", key)\
		.add_body_data("value", value)\
		.fetch()

## Requests the value of a server-side datastore for a player from its key.
func get_server(user_id: String, key: String) -> EzchaDatastoreValueResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/datastores/server")\
		.set_authentication(_ezcha.get_api_key())\
		.set_response_object(EzchaDatastoreValueResponse.new())\
		.add_query_parameter("user_id", user_id)\
		.add_query_parameter("key", key)\
		.fetch()

## Updates the value of a server-side datastore for a player by its key.
func post_server(user_id: String, key: String, value: String) -> EzchaResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/datastores/server")\
		.set_authentication(_ezcha.get_api_key())\
		.add_body_data("user_id", user_id)\
		.add_body_data("key", key)\
		.add_body_data("value", value)\
		.fetch()
