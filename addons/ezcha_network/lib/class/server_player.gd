extends RefCounted
class_name EzchaServerPlayer
## A helper class for managing player data (sessions, user info, trophies, etc) on a server.
##
## You shouldn't use this client-side or when making a singleplayer game.
## In those cases you should use Ezcha.client instead.

## Emitted once a session token has been authenticated.
signal authentication_completed(successful: bool)

## Emitted when a trophy grant is queued from the grant_trophy function.
## trophy_data will be null if the grant could not be queued.
signal trophy_grant_completed(trophy_id: String, successful: bool, trophy_data: EzchaTrophyMeta)

## Emitted when a leaderboard update is queued from the update_score function.
signal leaderboard_update_completed(leaderboard_id: String, successful: bool)

## The user data of the player.
## Only available after authenticating.
var user: EzchaUser = null

## The trophies that the user has obtained from this game.
var trophies_obtained: Array[EzchaTrophyMeta] = []

## The leaderboard entries that the currently authenticated user has for this game.
var leaderboard_entries: Array[EzchaLeaderboardEntry] = []

## If true the user should have access to any moderation tools.
var moderation_tools: bool = false

var _ezcha: Node = null
var _obtained_trophy_ids: PackedStringArray = PackedStringArray()
var _pending_trophy_ids: PackedStringArray = PackedStringArray()
var _web_bridge: EzchaWebBridge = EzchaWebBridge.new()
var _authenticated: bool = false

func _init():
	_ezcha = Engine.get_main_loop().root.get_node("Ezcha")

## Authenticates a session token and loads player information.
## (Async) Returns true if authentication was successful.
## The authentication_completed signal is emitted on completion.
func authenticate(session_token: String) -> bool:
	if (_authenticated): return true
	var response: EzchaSessionValidationResponse = _ezcha.sessions.post_validation(session_token, _ezcha.get_game_id())
	await response.recieved
	if (!response.is_successful()):
		authentication_completed.emit(false)
		return false
	_authenticated = true
	user = response.user
	trophies_obtained = response.trophies_obtained
	for trophy in trophies_obtained:
		_obtained_trophy_ids.append(trophy.id)
	leaderboard_entries = response.leaderboard_entries
	moderation_tools = response.moderation_tools
	authentication_completed.emit(true)
	return true

## Returns true if the player has authenticated and user data is available.
func is_authenticated() -> bool:
	return _authenticated

## Returns true if the player has the trophy specified.
func has_trophy(trophy_id: String, include_pending: bool = true) -> bool:
	if (include_pending && _pending_trophy_ids.has(trophy_id)): return true
	return _obtained_trophy_ids.has(trophy_id)

## Grants a trophy to the currently authenticated user.
## (Async) Returns true if the trophy grant was queued.
func grant_trophy(trophy_id: String) -> bool:
	if (!_authenticated): return false
	if (has_trophy(trophy_id, true)): return false
	_pending_trophy_ids.append(trophy_id)
	var response: EzchaTrophyQueuedResponse = _ezcha.trophies.post_grant_server(trophy_id, user.id)
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
## (Async) Returns true if the score update was queued.
func update_score(leaderboard_id: String, score: float, mode: EzchaLeaderboardsAPI.UpdateMode = EzchaLeaderboardsAPI.UpdateMode.SET) -> bool:
	if (!_authenticated): return false
	var response: EzchaLeaderboardQueuedResponse = _ezcha.leaderboards.post_entry_server(leaderboard_id, user.id, score, mode)
	await response.recieved
	if (!response.is_successful() || !response.queued):
		leaderboard_update_completed.emit(leaderboard_id, false)
		return false
	leaderboard_update_completed.emit(leaderboard_id, true)
	return true
