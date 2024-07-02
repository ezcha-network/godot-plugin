extends Object
class_name EzchaClient
## A helper class to simplify Ezcha Network API integration within game clients.
##
## This should be accessed through the "Ezcha" singleton.

## Emitted once the authentication process has completed.
## (successful: bool)
signal authentication_completed

## Emitted when a trophy grant is queued from the grant_trophy function.
## trophy_data will be null if the grant could not be queued.
## (trophy_id: String, successful: bool, trophy_data: EzchaTrophyMeta)
signal trophy_grant_completed

## Emitted when a leaderboard update is queued from the update_score function.
## (leaderboard_id: String, successful: bool)
signal leaderboard_update_completed

## The user who is currently playing the game.
## Only available after authenticating.
var user: EzchaUser = null

## The trophies that the currently authenticated user has obtained from this game.
## (EzchaTrophyMeta)
var trophies_obtained: Array = []

## The leaderboard entries that the currently authenticated user has for this game.
## (EzchaLeaderboardEntry)
var leaderboard_entries: Array = []

## If true the user should have access to any moderation tools.
var moderation_tools: bool = false

var _ezcha: Node = null
var _obtained_trophy_ids: PoolStringArray = PoolStringArray()
var _pending_trophy_ids: PoolStringArray = PoolStringArray()
var _web_bridge: EzchaWebBridge = EzchaWebBridge.new()
var _authenticated: bool = false
var _session_token: String = ""

func _on_validation_response(response: EzchaSessionValidationResponse, token: String) -> void:
	if (!response.is_successful()):
		emit_signal("authentication_completed", false)
		return
	_authenticated = true
	_session_token = token
	user = response.user
	trophies_obtained = response.trophies_obtained
	for trophy in trophies_obtained:
		_obtained_trophy_ids.append(trophy.id)
	leaderboard_entries = response.leaderboard_entries
	moderation_tools = response.moderation_tools
	emit_signal("authentication_completed", true)

func _validate_session(token):
	if (token == null):
		emit_signal("authentication_completed", false)
		return false
	var response: EzchaSessionValidationResponse = _ezcha.sessions.post_validation(token, _ezcha.get_game_id())
	response.connect("recieved", self, "_on_validation_response", [token], CONNECT_ONESHOT)

## Authenticates and loads the information of the current player if available.
## The authentication_completed signal is emitted on completion.
func authenticate() -> void:
	if (_authenticated): return
	# Check for session override debug option
	var session_override: String = _ezcha.get_session_override()
	if (OS.is_debug_build() && session_override != ""):
		_validate_session(session_override)
		return
	# Get token from bridge
	if (OS.get_name() != "HTML5"):
		emit_signal("authentication_completed", false)
		return
	_web_bridge.connect("_session_token_response", self, "_validate_session", [], CONNECT_ONESHOT)
	_web_bridge._request_session_token()

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

func _on_trophy_queued_response(response: EzchaTrophyQueuedResponse, trophy_id: String) -> void:
	var idx: int = _pending_trophy_ids.find(trophy_id)
	if (idx > -1): _pending_trophy_ids.remove(idx)
	if (!response.is_successful() || !response.queued):
		emit_signal("trophy_grant_completed", trophy_id, false, null)
		return
	trophies_obtained.append(response.trophy)
	_obtained_trophy_ids.append(response.trophy.id)
	emit_signal("trophy_grant_completed", trophy_id, true, response.trophy)

## Grants a trophy to the currently authenticated player.
## The trophy must have the "allow clients" option enabled.
## The trophy_grant_completed signal is emitted on completion.
## Returns null if the player is not yet authenticated or already has the trophy.
## Returns EzchaTrophyQueuedResponse otherwise.
func grant_trophy(trophy_id: String) -> EzchaTrophyQueuedResponse:
	if (!_authenticated): return null
	if (has_trophy(trophy_id, true)): return null
	_pending_trophy_ids.append(trophy_id)
	var response: EzchaTrophyQueuedResponse = _ezcha.trophies.post_grant_client(trophy_id, _session_token)
	response.connect("recieved", self, "_on_trophy_queued_response", [trophy_id], CONNECT_ONESHOT)
	return response

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

func _on_leaderboard_queued_response(response: EzchaLeaderboardQueuedResponse, leaderboard_id: String) -> void:
	if (!response.is_successful() || !response.queued):
		emit_signal("leaderboard_update_completed", leaderboard_id, false)
		return
	emit_signal("leaderboard_update_completed", leaderboard_id, true)

## Updates a leaderboard entry belonging to the currently authenticated player.
## The leaderboard must have the "allow clients" option enabled.
## The leaderboard_update_completed signal is emitted on completion.
## Mode should be EzchaLeaderboardsAPI.UpdateMode
## Returns null if the player is not yet authenticated.
## Returns EzchaLeaderboardQueuedResponse otherwise.
func update_score(leaderboard_id: String, score: float, mode: int = EzchaLeaderboardsAPI.UpdateMode.SET) -> EzchaLeaderboardQueuedResponse:
	if (!_authenticated): return null
	var response: EzchaLeaderboardQueuedResponse = _ezcha.leaderboards.post_entry_client(leaderboard_id, _session_token, score, mode)
	response.connect("recieved", self, "_on_leaderboard_queued_response", [leaderboard_id], CONNECT_ONESHOT)
	return response
	
