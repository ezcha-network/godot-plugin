extends EzchaAPI
class_name EzchaGeneralAPI
## A wrapper for the general section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Returns the current status of the API.
func get_status() -> EzchaGeneralStatusResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/general/status")\
		.set_response_object(EzchaGeneralStatusResponse.new())\
		.fetch()

## Returns the current time from API.
func get_time() -> EzchaGeneralTimeResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/general/time")\
		.set_response_object(EzchaGeneralTimeResponse.new())\
		.fetch()

## Validates a captcha response.
func post_captcha(response: String) -> EzchaCaptchaResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_POST)\
		.set_endpoint("/v1/general/captcha")\
		.set_response_object(EzchaCaptchaResponse.new())\
		.add_body_data("response", response)\
		.fetch()
