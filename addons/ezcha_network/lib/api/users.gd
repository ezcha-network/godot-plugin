extends EzchaAPI
class_name EzchaUsersAPI
## A wrapper for the users section of the API.
##
## This should be accessed through the "Ezcha" singleton.

## Requests a user from their ID.
func get_from_id(user_id: String) -> EzchaUserResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users")\
		.set_response_object(EzchaUserResponse.new())\
		.add_query_parameter("user_id", user_id)\
		.fetch()

## Requests a user from their name.
func get_from_name(username: String) -> EzchaUserResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users")\
		.set_response_object(EzchaUserResponse.new())\
		.add_query_parameter("username", username)\
		.fetch()

## Requests several users at once.
func get_many(user_ids: PackedStringArray, usernames: PackedStringArray = PackedStringArray()) -> EzchaUsersResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users")\
		.set_response_object(EzchaUsersResponse.new())\
		.add_query_parameter("user_id", user_ids)\
		.add_query_parameter("username", usernames)\
		.add_query_parameter("force_list", true)\
		.fetch()

## Returns a paginated list of user based on the criteria provided.
func get_list(page: int = 1, category: String = "", order: String = "") -> EzchaUserListResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users/list")\
		.set_response_object(EzchaUserListResponse.new())\
		.add_query_parameter("page", page)\
		.add_query_parameter("category", category)\
		.add_query_parameter("order", order)\
		.fetch()

## Lists the trophies a user has obtained for the game specified
func get_trophies(user_id: String, game_id: String) -> EzchaTrophyObtainedListResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users/trophies")\
		.set_response_object(EzchaTrophyObtainedListResponse.new())\
		.add_query_parameter("user_id", user_id)\
		.add_query_parameter("game_id", game_id)\
		.fetch()

## Check if two users are friends
func check_friends(user_id_a: String, user_id_b: String) -> EzchaFriendsResponse:
	return EzchaRequestBuilder.new()\
		.set_method(HTTPClient.METHOD_GET)\
		.set_endpoint("/v1/users/friends/check")\
		.set_response_object(EzchaFriendsResponse.new())\
		.add_query_parameter("user_id_a", user_id_a)\
		.add_query_parameter("user_id_b", user_id_b)\
		.fetch()
