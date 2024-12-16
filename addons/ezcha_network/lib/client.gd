extends Object
class_name EzchaClient
## A helper class to simplify Ezcha Network API integration within game clients.
##
## This should be accessed through the "Ezcha" singleton.

## Emitted once the authentication process has completed.
signal authentication_completed(successful: bool)

## Emitted once logged out (not support on web).
signal logout_completed(successful: bool)

## Emitted when a trophy grant is queued from the grant_trophy function.
## trophy_data will be null if the grant could not be queued.
signal trophy_grant_completed(trophy_id: String, successful: bool, trophy_data: EzchaTrophyMeta)

## Emitted when a leaderboard update is queued from the update_score function.
signal leaderboard_update_completed(leaderboard_id: String, successful: bool)

## Emitted after a datastore value is requested and recieved
signal datastore_value_recieved(key: String, value: String)

## Emitted after a datastore value update is posted.
signal datastore_value_posted(key: String, successful: bool)

## The user who is currently playing the game.
## Only available after authenticating.
var user: EzchaUser = null

## The trophies that the currently authenticated user has obtained from this game.
var trophies_obtained: Array[EzchaTrophyMeta] = []

## The leaderboard entries that the currently authenticated user has for this game.
var leaderboard_entries: Array[EzchaLeaderboardEntry] = []

## If true the user should have access to any moderation tools.
var moderation_tools: bool = false

var _adapter: EzchaPlatformAdapter = null
var _ezcha: Node = null
var _obtained_trophy_ids: PackedStringArray = PackedStringArray()
var _pending_trophy_ids: PackedStringArray = PackedStringArray()
var _authenticated: bool = false
var _session_token: String = ""

func _init() -> void:
	# Set default web adapter
	if (OS.get_name() != "Web"): return
	_adapter = EzchaPlatformAdapterWeb.new()

func _validate_session(token: String) -> bool:
	var response: EzchaSessionValidationResponse = _ezcha.sessions.post_validation(token, _ezcha.get_game_id())
	await response.recieved
	if (!response.is_successful()):
		authentication_completed.emit(false)
		return false
	_authenticated = true
	_session_token = token
	user = response.user
	trophies_obtained = response.trophies_obtained
	for trophy in trophies_obtained:
		_obtained_trophy_ids.append(trophy.id)
	leaderboard_entries = response.leaderboard_entries
	moderation_tools = response.moderation_tools
	authentication_completed.emit(true)
	return true

## Authenticates and loads the information of the current player if available.
## This should be ran at the start of the game.
## The authentication_completed signal is emitted on completion.
##
## (Async) Returns true if authentication was successful.
func authenticate() -> bool:
	if (_authenticated):
		authentication_completed.emit(true)
		return true
	
	# Check for session override debug option
	var session_override: String = _ezcha.get_session_override()
	if (OS.is_debug_build() && session_override != ""):
		return await _validate_session(session_override)
	
	# Request token from adapter
	if (_adapter == null):
		authentication_completed.emit(false)
		return false
	_adapter._start_auth_flow()
	var token = await _adapter.auth_flow_completed
	if (token == null):
		authentication_completed.emit(false)
		return false
	return await _validate_session(token)

## Returns true if the current platform allows for native login/logout.
func supports_native_login() -> bool:
	if (_adapter == null): return false
	return _adapter.supports_login()

## Requests the native login flow for platforms that support it.
## This can be ran at the user's request if automatic authentication fails.
## The authentication_completed signal is emitted on completion.
##
## (Async) Returns true if authentication was successful.
func request_login() -> bool:
	if (_authenticated): return true
	
	# Check for session override debug option
	var session_override: String = _ezcha.get_session_override()
	if (OS.is_debug_build() && session_override != ""):
		return await _validate_session(session_override)
	
	# Request login flow from adapter
	if (_adapter == null): return false
	if (!_adapter.supports_login()): return false
	_adapter._start_login_flow()
	var token = await _adapter.login_flow_completed
	if (token == null):
		authentication_completed.emit(false)
		return false
	return await _validate_session(token)

## Requests to logout the current user for platforms that support it.
## The logout_completed signal is emitted on completion.
##
## (Async) Returns true if logout was successful.
func request_logout() -> bool:
	if (!_authenticated): return true
	
	# Request logout from adapter
	if (_adapter == null): return false
	if (!_adapter.supports_login()): return false
	var success: bool = await _adapter._logout()
	if (success):
		user = null
		trophies_obtained.clear()
		leaderboard_entries.clear()
		moderation_tools = false
		_obtained_trophy_ids.clear()
		_pending_trophy_ids.clear()
		_authenticated = false
		_session_token = ""
	logout_completed.emit(success)
	return success

## Returns true if the client has authenticated and user data is available.
func is_authenticated() -> bool:
	return _authenticated

## Returns the player's session token if authenticated.
func get_session_token() -> String:
	return _session_token

## Returns true if the currently authenticated player has the trophy specified.
func has_trophy(trophy_id: String, include_pending: bool = true) -> bool:
	if (include_pending && _pending_trophy_ids.has(trophy_id)): return true
	return _obtained_trophy_ids.has(trophy_id)

## Grants a trophy to the currently authenticated player.
## The trophy must have the "allow clients" option enabled.
## The trophy_grant_completed signal is emitted on completion.
##
## (Async) Returns true if the trophy grant was queued.
func grant_trophy(trophy_id: String) -> bool:
	if (!_authenticated): return false
	if (has_trophy(trophy_id, true)): return false
	_pending_trophy_ids.append(trophy_id)
	var response: EzchaTrophyQueuedResponse = _ezcha.trophies.post_grant_client(trophy_id, _session_token)
	await response.recieved
	var idx: int = _pending_trophy_ids.find(trophy_id)
	if (idx > -1): _pending_trophy_ids.remove_at(idx)
	if (!response.is_successful() || !response.queued):
		trophy_grant_completed.emit(trophy_id, false, null)
		return false
	trophies_obtained.append(response.trophy)
	_obtained_trophy_ids.append(response.trophy.id)
	trophy_grant_completed.emit(trophy_id, true, response.trophy)
	return true

## Checks if the currently authenticated player has a score on a leaderboard.
func has_score(leaderboard_id: String) -> bool:
	for entry in leaderboard_entries:
		if (entry.leaderboard.id == leaderboard_id): return true
	return false

## Returns the currently authenticated player's score on a specific leaderboard.
func get_score(leaderboard_id: String, defaults_to: float = 0.0) -> float:
	for entry in leaderboard_entries:
		if (entry.leaderboard.id == leaderboard_id): return entry.score
	return defaults_to

## Updates a leaderboard entry belonging to the currently authenticated player.
## The leaderboard must have the "allow clients" option enabled.
## The leaderboard_update_completed signal is emitted on completion.
##
## (Async) Returns true if the score update was queued.
func update_score(leaderboard_id: String, score: float, mode: EzchaLeaderboardsAPI.UpdateMode = EzchaLeaderboardsAPI.UpdateMode.SET) -> bool:
	if (!_authenticated): return false
	var response: EzchaLeaderboardQueuedResponse = _ezcha.leaderboards.post_entry_client(leaderboard_id, _session_token, score, mode)
	await response.recieved
	if (!response.is_successful() || !response.queued):
		leaderboard_update_completed.emit(leaderboard_id, false)
		return false
	leaderboard_update_completed.emit(leaderboard_id, true)
	return true

## Get a datastore value belonging to the currently authenticated player.
## The datastore_value_recieved signal is emitted when the value is recieved.
##
## (Async) Returns a string value. The value will be empty if deleted or not yet set.
func get_datastore(key: String) -> String:
	if (!_authenticated): return ""
	var response: EzchaDatastoreValueResponse = _ezcha.datastores.get_client(key, _session_token)
	await response.recieved
	if (!response.is_successful()):
		datastore_value_recieved.emit(key, "")
		return ""
	datastore_value_recieved.emit(key, response.value)
	return response.value

## Update a datastore value belonging to the currently authenticated player.
## Limit of 5 keys per user, limit of 16384 characters per value.
## Set the value to an empty string to delete the key.
## The datastore_value_posted signal is emitted on completion.
##
## (Async) Returns true if the value was successfully updated.
func set_datastore(key: String, value: String) -> bool:
	if (!_authenticated): false
	var response: EzchaResponse = _ezcha.datastores.post_client(key, value, _session_token)
	await response.recieved
	if (!response.is_successful()):
		datastore_value_posted.emit(key, false)
		return false
	datastore_value_posted.emit(key, true)
	return true
