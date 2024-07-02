extends EzchaAPI
class_name EzchaNewsAPI
## A wrapper for the news section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Returns a paginated list of news posts based on the criteria provided.
func get_list(page: int = 1, category: String = "", series: String = "", order: String = "") -> EzchaPaginatedNewsListResponse:
	var resp: EzchaPaginatedNewsListResponse = EzchaPaginatedNewsListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/news/list")\
		.set_response_object(resp)\
		.add_query_parameter("page", page)\
		.add_query_parameter("category", category)\
		.add_query_parameter("series", series)\
		.add_query_parameter("order", order)\
		.fetch()
	return resp
