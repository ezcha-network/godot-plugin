extends EzchaAPI
class_name EzchaGeneralAPI
## A wrapper for the general section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Returns the current status of the API.
func get_status() -> EzchaGeneralStatusResponse:
	var resp: EzchaGeneralStatusResponse = EzchaGeneralStatusResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/general/status")\
		.set_response_object(resp)\
		.fetch()
	return resp

## Returns the current time from API.
func get_time() -> EzchaGeneralTimeResponse:
	var resp: EzchaGeneralTimeResponse = EzchaGeneralTimeResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/general/time")\
		.set_response_object(resp)\
		.fetch()
	return resp
