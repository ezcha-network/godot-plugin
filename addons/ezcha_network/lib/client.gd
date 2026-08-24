extends Object
class_name EzchaClient
## A helper class to simplify Ezcha Network API integration within game clients.
##
## This should be accessed through the "Ezcha" singleton.

const _RELAY_PING_BATCH_LIMIT: int = 5

## Emitted when the authentication process has completed.
signal authentication_completed(successful: bool)

## Emitted when the login flow has completed. (not support on web).
signal login_completed(successful: bool)

## Emitted when the user logs out. (not support on web).
signal logout_completed(successful: bool)

## Emitted if the session has expired or is otherwise no longer valid.
signal session_expired()

## Emitted when a trophy grant is queued from the grant_trophy function.
## trophy_data will be null if the grant could not be queued.
signal trophy_grant_completed(trophy_id: String, successful: bool, trophy_data: EzchaTrophy)

## Emitted when a leaderboard update is queued from the update_score function.
signal leaderboard_update_completed(leaderboard_id: String, successful: bool)

## Emitted after a datastore value is requested and received.
signal datastore_value_received(key: String, value: String)

## Emitted after a datastore value update is posted.
signal datastore_value_posted(key: String, successful: bool)

## The user who is currently playing the game.
## Only available after authenticating.
var user: EzchaUser = null

## The trophies that the currently authenticated user has obtained from this game.
var trophies_obtained: Array[EzchaTrophyObtained] = []

## The leaderboard entries that the currently authenticated user has for this game.
var leaderboard_entries: Array[EzchaLeaderboardEntry] = []

## The total amount that the currently authenticated user has tipped for this game.
## This is measured in USD cents.
var tipped_amount: int = 0

## If true the user should have access to any moderation tools.
var moderation_tools: bool = false

var _adapter: EzchaPlatformAdapter = null
var _ezcha: EzchaSingleton = null
var _obtained_trophy_ids: PackedStringArray = PackedStringArray()
var _pending_trophy_ids: PackedStringArray = PackedStringArray()
var _authenticated: bool = false
var _session_token: String = ""

# Lifecycle

func _init(ezcha: EzchaSingleton) -> void:
	_ezcha = ezcha
	# Set default web adapter
	if (OS.get_name() != "Web"): return
	_adapter = EzchaWebAdapter.new(ezcha)

# Interface

## Authenticates and loads the information of the current player if available.
## This should be ran at the start of the game.
## The authentication_completed signal is emitted on completion.
##
## (Async) Returns true if authentication was successful.
func authenticate() -> bool:
	if (_authenticated):
		authentication_completed.emit(true)
		return true
	
	var test_session: String = EzchaOpts._get_test_session_temp()
	if (!test_session.is_empty()):
		return await _validate_session(test_session)
	
	if (_adapter == null):
		authentication_completed.emit(false)
		return false
	_adapter._start_auth_flow()
	var token: String = await _adapter.auth_flow_completed
	if (token.is_empty()):
		authentication_completed.emit(false)
		return false
	return await _validate_session(token)

## Returns the current platform adapter.
func get_adapter() -> EzchaPlatformAdapter:
	return _adapter

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
	if (_adapter == null): return false
	if (!_adapter.supports_login()): return false
	_adapter._start_login_flow()
	var token: String = await _adapter.login_flow_completed
	if (token.is_empty()):
		authentication_completed.emit(false)
		login_completed.emit(false)
		return false
	var validated: bool = await _validate_session(token)
	login_completed.emit(validated)
	return validated

## Requests to logout the current user for platforms that support it.
## The logout_completed signal is emitted on completion.
##
## (Async) Returns true if logout was successful.
func request_logout() -> bool:
	if (!_authenticated): return true
	if (_adapter == null): return false
	if (!_adapter.supports_login()): return false
	var success: bool = await _adapter._logout()
	if (success): _reset_state()
	logout_completed.emit(success)
	return success

## Opens the account management page for platforms that support it.
##
## (Async) Returns once the user closes the page.
func request_account_management() -> void:
	if (_adapter == null): return
	if (!_adapter.supports_login()): return
	await _adapter._request_account_management()

## Returns true if the client has authenticated and user data is available.
func is_authenticated() -> bool:
	return _authenticated

## Returns true if the user has a guest profile loaded from a relay lobby.
func is_guest() -> bool:
	return (user != null && user.guest)

## Returns the player's session token if authenticated.
func get_session_token() -> String:
	return _session_token

## Returns true if the currently authenticated player has the trophy specified.
func has_trophy(trophy_id: String, include_pending: bool = true) -> bool:
	if (include_pending && _pending_trophy_ids.has(trophy_id)): return true
	return _obtained_trophy_ids.has(trophy_id)

## Returns the trophy if the player has obtained it, null otherwise.
func get_trophy(trophy_id: String) -> EzchaTrophyObtained:
	for trophy: EzchaTrophyObtained in trophies_obtained:
		if (trophy.id == trophy_id): return trophy
	return null

## Grants a trophy to the currently authenticated player.
## The trophy must have the "allow clients" option enabled.
## The trophy_grant_completed signal is emitted on completion.
##
## (Async) Returns true if the trophy grant was queued.
func grant_trophy(trophy_id: String) -> bool:
	if (!_authenticated):
		printerr(EzchaOpts._PRINT_PREFIX + "User must be authenticated before granting trophies.")
		return false
	if (user.guest):
		printerr(EzchaOpts._PRINT_PREFIX + "Guests cannot be granted trophies.")
		return false
	if (has_trophy(trophy_id, true)):
		printerr(EzchaOpts._PRINT_PREFIX + "User has already obtained this trophy.")
		return false
	_pending_trophy_ids.append(trophy_id)
	var response: EzchaTrophyQueuedResponse = await _ezcha.trophies.post_grant_client(
		trophy_id, _session_token
	).async()
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
	for entry: EzchaLeaderboardEntry in leaderboard_entries:
		if (entry.leaderboard.id == leaderboard_id): return true
	return false

## Returns the currently authenticated player's score on a specific leaderboard.
func get_score(leaderboard_id: String, defaults_to: float = 0.0) -> float:
	for entry: EzchaLeaderboardEntry in leaderboard_entries:
		if (entry.leaderboard.id == leaderboard_id): return entry.score
	return defaults_to

## Updates a leaderboard entry belonging to the currently authenticated player.
## The leaderboard must have the "allow clients" option enabled.
## The leaderboard_update_completed signal is emitted on completion.
##
## (Async) Returns true if the score update was queued.
func update_score(leaderboard_id: String, score: float, mode: EzchaLeaderboardsAPI.UpdateMode = EzchaLeaderboardsAPI.UpdateMode.SET) -> bool:
	if (!_authenticated):
		printerr(EzchaOpts._PRINT_PREFIX + "User must be authenticated before tracking scores.")
		return false
	if (user.guest):
		printerr(EzchaOpts._PRINT_PREFIX + "Guests cannot track scores.")
		return false
	var response: EzchaLeaderboardQueuedResponse = await _ezcha.leaderboards.post_entry_client(
		leaderboard_id, _session_token, score, mode
	).async()
	if (!response.is_successful() || !response.queued):
		leaderboard_update_completed.emit(leaderboard_id, false)
		return false
	leaderboard_update_completed.emit(leaderboard_id, true)
	return true

# Datastores

## Get a datastore value belonging to the currently authenticated player.
## The datastore_value_received signal is emitted when the value is received.
##
## (Async) Returns a string value. The value will be empty if unset.
func get_datastore(key: String) -> String:
	if (!_authenticated):
		printerr(EzchaOpts._PRINT_PREFIX + "User must be authenticated before accessing datastores.")
		return ""
	if (user.guest):
		printerr(EzchaOpts._PRINT_PREFIX + "Guests cannot access datastores.")
		return ""
	var response: EzchaDatastoreValueResponse = await _ezcha.datastores.get_client(
		key, _session_token
	).async()
	if (!response.is_successful()):
		datastore_value_received.emit(key, "")
		return ""
	datastore_value_received.emit(key, response.value)
	return response.value

## Update a datastore value belonging to the currently authenticated player.
## Limit of 5 keys per user, limit of 16384 characters per value.
## Set the value to an empty string to delete the key.
## The datastore_value_posted signal is emitted on completion.
##
## (Async) Returns true if the value was successfully updated.
func set_datastore(key: String, value: String) -> bool:
	if (!_authenticated):
		printerr(EzchaOpts._PRINT_PREFIX + "User must be authenticated before accessing datastores.")
		return false
	if (user.guest):
		printerr(EzchaOpts._PRINT_PREFIX + "Guests cannot access datastores.")
		return false
	var response: EzchaResponse = await _ezcha.datastores.post_client(
		key, value, _session_token
	).async()
	if (!response.is_successful()):
		datastore_value_posted.emit(key, false)
		return false
	datastore_value_posted.emit(key, true)
	return true

## Test relay servers and return them based on latency.
##
## (Async) Returns an array of available servers, sorted from lowest to highest latency.
func order_relay_servers() -> Array[EzchaRelayServer]:
	# Get available relay servers
	var list_res: EzchaRelayServerListResponse = await _ezcha.relay.get_servers().async()
	if (!list_res.is_successful()): return []
	if (list_res.servers.is_empty()): return []
	# Batch servers for testingg
	var server_count: int = list_res.servers.size()
	var batch_count: int = ceili(float(server_count) / float(_RELAY_PING_BATCH_LIMIT))
	var ping_results: Array[int] = []
	for idx: int in batch_count:
		var start: int = idx * _RELAY_PING_BATCH_LIMIT
		var end: int = mini((idx + 1) * _RELAY_PING_BATCH_LIMIT, server_count)
		var servers: Array[EzchaRelayServer] = list_res.servers.slice(start, end)
		# Test latency of servers
		var batch: EzchaAsyncBatch = EzchaAsyncBatch.new()
		for server: EzchaRelayServer in servers: batch.add(server.ping, [])
		ping_results.append_array(await batch.watch())
	# Map server/ping, exclude if test failed
	var ping_map: Dictionary[EzchaRelayServer, int] = {}
	for idx: int in server_count:
		var ping: int = ping_results[idx]
		if (ping < 0): continue
		ping_map[list_res.servers[idx]] = ping
	# Sort final results based on ping
	var final_results: Array[EzchaRelayServer] = ping_map.keys()
	final_results.sort_custom(_relay_ping_sort.bind(ping_map))
	return final_results

func _relay_ping_sort(a: EzchaRelayServer, b: EzchaRelayServer, map: Dictionary[EzchaRelayServer, int]) -> bool:
	return (map[a] < map[b])

## Determines the ideal Ezcha Relay server for the user.
##
## (Async) Returns a server if available, null otherwise.
func determine_relay_server() -> EzchaRelayServer:
	var results: Array[EzchaRelayServer] = await order_relay_servers()
	if (results.is_empty()): return null
	return results[0]

## Fetches a list of open Ezcha Relay lobbies for the current game and version.
##
## Returns an EzchaLobbyListResponse object.
func get_relay_lobbies(page: int = 1, game_mode: int = -1) -> EzchaLobbyListResponse:
	return _ezcha.relay.get_lobbies(
		_ezcha.get_game_id(),
		page,
		EzchaUtil.get_game_version(),
		game_mode
	)

# Internal helpers

func _reset_state() -> void:
	user = null
	trophies_obtained.clear()
	leaderboard_entries.clear()
	tipped_amount = 0
	moderation_tools = false
	_obtained_trophy_ids.clear()
	_pending_trophy_ids.clear()
	_authenticated = false
	_session_token = ""

func _simulate_guest_session(guest_user: EzchaUser) -> void:
	user = guest_user
	_authenticated = true

func _validate_session(token: String) -> bool:
	var response: EzchaSessionValidationResponse = await _ezcha.sessions.post_validation(
		token, _ezcha.get_game_id()
	).async()
	if (!response.is_successful()):
		authentication_completed.emit(false)
		return false
	_authenticated = true
	_session_token = token
	user = response.user
	trophies_obtained = response.trophies_obtained
	for trophy: EzchaTrophyObtained in trophies_obtained:
		_obtained_trophy_ids.append(trophy.id)
	leaderboard_entries = response.leaderboard_entries
	tipped_amount = response.tipped_amount
	moderation_tools = response.moderation_tools
	if (_adapter != null):
		_adapter.session_expired.connect(_on_session_expired, CONNECT_ONE_SHOT)
	authentication_completed.emit(true)
	return true

# Events

func _on_session_expired() -> void:
	_reset_state()
	session_expired.emit()
