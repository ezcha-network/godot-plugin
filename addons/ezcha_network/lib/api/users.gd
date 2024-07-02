extends EzchaAPI
class_name EzchaUsersAPI
## A wrapper for the users section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Requests a user from their ID.
func get_from_id(user_id: String) -> EzchaUserResponse:
	var resp: EzchaUserResponse = EzchaUserResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users")\
		.set_response_object(resp)\
		.add_query_parameter("user_id", user_id)\
		.fetch()
	return resp

## Requests a user from their name.
func get_from_name(username: String) -> EzchaUserResponse:
	var resp: EzchaUserResponse = EzchaUserResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users")\
		.set_response_object(resp)\
		.add_query_parameter("username", username)\
		.fetch()
	return resp

## Requests several users at once.
func get_many(user_ids: PoolStringArray, usernames: PoolStringArray = PoolStringArray()) -> EzchaUserListResponse:
	var resp: EzchaUserListResponse = EzchaUserListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users")\
		.set_response_object(resp)\
		.add_query_parameter("user_id", user_ids)\
		.add_query_parameter("username", usernames)\
		.add_query_parameter("force_list", true)\
		.fetch()
	return resp

## Returns a paginated list of user based on the criteria provided.
func get_list(page: int = 1, category: String = "", order: String = "") -> EzchaPaginatedUserListResponse:
	var resp: EzchaPaginatedUserListResponse = EzchaPaginatedUserListResponse.new()
	EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users/list")\
		.set_response_object(resp)\
		.add_query_parameter("page", page)\
		.add_query_parameter("category", category)\
		.add_query_parameter("order", order)\
		.fetch()
	return resp
