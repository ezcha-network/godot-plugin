extends EzchaAPI
class_name EzchaProductsAPI
## A wrapper for the products section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Verifies and optionally consumes a product purchase client-side.
func post_verify_client(purchase_id: String, consume: bool, session_token: String) -> EzchaProductVerifyResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/products/verify/client")\
		.set_authentication(session_token)\
		.set_response_object(EzchaProductVerifyResponse.new())\
		.add_body_data("purchase_id", purchase_id)\
		.add_body_data("consume", consume)\
		.fetch()

## Verifies and optionally consumes a product purchase server-side.
func post_verify_server(purchase_id: String, consume: bool, user_id: String) -> EzchaProductVerifyResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/products/verify/server")\
		.set_authentication(_ezcha.get_api_key())\
		.set_response_object(EzchaProductVerifyResponse.new())\
		.add_body_data("purchase_id", purchase_id)\
		.add_body_data("consume", consume)\
		.add_body_data("user_id", user_id)\
		.fetch()
