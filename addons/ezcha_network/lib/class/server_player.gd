extends Reference
class_name EzchaServerPlayer
## A helper class for managing player data (sessions, user info, trophies, etc) on a server.
##
## You shouldn't use this client-side or when making a singleplayer game.
## In those cases you should use Ezcha.client instead.

## Emitted once a session token has been authenticated.
## (successful: bool, player: EzchaServerPlayer)
signal authentication_completed

## Emitted when a trophy grant is queued from the grant_trophy function.
## trophy_data will be null if the grant could not be queued.
## (trophy_id: String, successful: bool, trophy_data: EzchaTrophyMeta)
signal trophy_grant_completed

## Emitted when a leaderboard update is queued from the update_score function.
## (leaderboard_id: String, successful: bool)
signal leaderboard_update_completed

## Emitted after a datastore value is requested and recieved
## (key: String, value: String)
signal datastore_value_recieved

## Emitted after a datastore value update is posted.
## (key: String, successful: bool)
signal datastore_value_posted

## The user data of the player.
## Only available after authenticating.
var user: EzchaUser = null

## The trophies that the user has obtained from this game.
var trophies_obtained: Array = []

## The leaderboard entries that the currently authenticated user has for this game.
var leaderboard_entries: Array = []

## If true the user should have access to any moderation tools.
var moderation_tools: bool = false

var _ezcha: Node = null
var _obtained_trophy_ids: PoolStringArray = PoolStringArray()
var _pending_trophy_ids: PoolStringArray = PoolStringArray()
var _web_bridge: EzchaWebBridge = EzchaWebBridge.new()
var _authenticated: bool = false

func _init():
	_ezcha = Engine.get_main_loop().root.get_node("Ezcha")

## Authenticates a session token and loads player information.
## The authentication_completed signal is emitted on completion.
func authenticate(session_token: String) -> void:
	if (_authenticated): return
	var response: EzchaSessionValidationResponse = _ezcha.sessions.post_validation(session_token, _ezcha.get_game_id())
	yield(response, "recieved")
	if (!response.is_successful()):
		emit_signal("authentication_completed", false, null)
		return
	_authenticated = true
	user = response.user
	trophies_obtained = response.trophies_obtained
	for trophy in trophies_obtained:
		_obtained_trophy_ids.append(trophy.id)
	leaderboard_entries = response.leaderboard_entries
	moderation_tools = response.moderation_tools
	emit_signal("authentication_completed", true, self)

## Returns true if the player has authenticated and user data is available.
func is_authenticated() -> bool:
	return _authenticated

## Returns true if the player has the trophy specified.
func has_trophy(trophy_id: String, include_pending: bool = true) -> bool:
	if (include_pending && _pending_trophy_ids.has(trophy_id)): return true
	return _obtained_trophy_ids.has(trophy_id)

## Grants a trophy to the currently authenticated user.
## The trophy_grant_completed signal is emitted on completion.
## Returns null if the player is not yet authenticated or already has the trophy.
## Returns EzchaTrophyQueuedResponse otherwise.
func grant_trophy(trophy_id: String) -> EzchaTrophyQueuedResponse:
	if (!_authenticated): return null
	if (has_trophy(trophy_id, true)): return null
	_pending_trophy_ids.append(trophy_id)
	var response: EzchaTrophyQueuedResponse = _ezcha.trophies.post_grant_server(trophy_id, user.id)
	response.connect("recieved", self, "_on_trophy_queued_response", [trophy_id], CONNECT_ONESHOT)
	return response

func _on_trophy_queued_response(response: EzchaTrophyQueuedResponse, trophy_id: String) -> void:
	var idx: int = _pending_trophy_ids.find(trophy_id)
	if (idx > -1): _pending_trophy_ids.remove(idx)
	if (!response.is_successful() || !response.queued):
		emit_signal("trophy_grant_completed", trophy_id, false, null)
		return
	trophies_obtained.append(response.trophy)
	_obtained_trophy_ids.append(response.trophy.id)
	emit_signal("trophy_grant_completed", trophy_id, true, response.trophy)

## Checks if the player has a score on a leaderboard.
func has_score(leaderboard_id: String) -> bool:
	for entry in leaderboard_entries:
		if (entry.leaderboard.id == leaderboard_id): return true
	return false

## Returns the players's score on a specific leaderboard.
func get_score(leaderboard_id: String, defaults_to: float = 0.0) -> float:
	for entry in leaderboard_entries:
		if (entry.leaderboard.id == leaderboard_id): return entry.score
	return defaults_to

## Updates a leaderboard entry belonging to the player.
## The leaderboard_update_completed signal is emitted on completion.
## Mode should be EzchaLeaderboardsAPI.UpdateMode
## Returns null if the player is not yet authenticated.
## Returns EzchaLeaderboardQueuedResponse otherwise.
func update_score(leaderboard_id: String, score: float, mode: int = EzchaLeaderboardsAPI.UpdateMode.SET) -> EzchaLeaderboardQueuedResponse:
	if (!_authenticated): return null
	var response: EzchaLeaderboardQueuedResponse = _ezcha.leaderboards.post_entry_server(leaderboard_id, user.id, score, mode)
	response.connect("recieved", self, "_on_leaderboard_queued_response", [leaderboard_id], CONNECT_ONESHOT)
	return response

func _on_leaderboard_queued_response(response: EzchaLeaderboardQueuedResponse, leaderboard_id: String) -> void:
	if (!response.is_successful() || !response.queued):
		emit_signal("leaderboard_update_completed", leaderboard_id, false)
		return
	emit_signal("leaderboard_update_completed", leaderboard_id, true)

## Get a datastore value belonging to the currently authenticated player.
## The datastore_value_recieved signal is emitted when the value is recieved.
## Returns null if the player is not yet authenticated.
## Returns EzchaDatastoreValueResponse otherwise.
func get_datastore(key: String) -> EzchaDatastoreValueResponse:
	if (!_authenticated): return null
	var response: EzchaDatastoreValueResponse = _ezcha.datastores.get_server(user.id, key)
	response.connect("recieved", self, "_on_datastore_get_response", [key], CONNECT_ONESHOT)
	return response

func _on_datastore_get_response(response: EzchaDatastoreValueResponse, key: String) -> void:
	if (!response.is_successful()):
		emit_signal("datastore_value_recieved", key, "")
		return
	emit_signal("datastore_value_recieved", key, response.value)

## Update a datastore value belonging to the currently authenticated player.
## Limit of 5 keys per user, limit of 16384 characters per value.
## Set the value to an empty string to delete the key.
## The datastore_value_posted signal is emitted on completion.
## Returns null if the player is not yet authenticated.
## Returns EzchaResponse otherwise.
func set_datastore(key: String, value: String) -> EzchaResponse:
	if (!_authenticated): null
	var response: EzchaResponse = _ezcha.datastores.post_server(user.id, key, value)
	response.connect("recieved", self, "_on_datastore_set_response", [response, key], CONNECT_ONESHOT)
	return response

func _on_datastore_set_response(response: EzchaResponse, key: String) -> void:
	emit_signal("datastore_value_posted", key, response.is_successful())
