@tool
extends Node
class_name EzchaSingleton
## The class representing the "Ezcha" singleton.
##
## This is where most of the functionality the plugin offers is accessed from.

const _HOSTNAME: String = "https://ezcha.net"
const _HOSTNAME_API: String = "https://api.ezcha.net"

## A helper class to simplify Ezcha Network API integration within game clients.
var client: EzchaClient = EzchaClient.new()

## A wrapper for the datastores section of the API.
var datastores: EzchaDatastoresAPI = EzchaDatastoresAPI.new()

## A wrapper for the games section of the API.
var games: EzchaGamesAPI = EzchaGamesAPI.new()

## A wrapper for the general section of the API.
var general: EzchaGeneralAPI = EzchaGeneralAPI.new()

## A wrapper for the leaderboards section of the API.
var leaderboards: EzchaLeaderboardsAPI = EzchaLeaderboardsAPI.new()

## A wrapper for the news section of the API.
var news: EzchaNewsAPI = EzchaNewsAPI.new()

## A wrapper for the sessions section of the API.
var sessions: EzchaSessionsAPI = EzchaSessionsAPI.new()

## A wrapper for the trophies section of the API.
var trophies: EzchaTrophiesAPI = EzchaTrophiesAPI.new()

## A wrapper for the users section of the API.
var users: EzchaUsersAPI = EzchaUsersAPI.new()

func _init():
	client._ezcha = self
	datastores._ezcha = self
	games._ezcha = self
	general._ezcha = self
	leaderboards._ezcha = self
	news._ezcha = self
	sessions._ezcha = self
	trophies._ezcha = self
	users._ezcha = self

## A helper to return the currently configured game identifier.
func get_game_id() -> String:
	return ProjectSettings.get_setting("ezcha_network/config/global/game_id", "")

## A helper to return the currently configured API key.
func get_api_key() -> String:
	return ProjectSettings.get_setting("ezcha_network/config/server/api_key", "")

## A helper to return the currently configured signing key.
func get_signing_key() -> String:
	return ProjectSettings.get_setting("ezcha_network/config/client/signing_key", "")

## A helper to return the currently configured session override.
func get_session_override() -> String:
	if (!Engine.is_editor_hint() && !OS.is_debug_build()): return ""
	return ProjectSettings.get_setting("ezcha_network/config/debug/session_override", "")

## A helper to return if request errors should be printed.
func should_print_request_errors() -> bool:
	if (!Engine.is_editor_hint() && !OS.is_debug_build()): return false
	return ProjectSettings.get_setting("ezcha_network/config/debug/print_request_errors", false)
