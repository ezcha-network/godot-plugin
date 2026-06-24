@tool
extends Node
class_name EzchaSingleton
## The class representing the "Ezcha" singleton.
##
## This is where most of the plugin's functionality is accessed from.

const _HOSTNAME: String = "https://ezcha.net"

## A helper class to simplify Ezcha Network API integration within game clients.
var client: EzchaClient = EzchaClient.new(self)

## A wrapper for the datastores section of the API.
var datastores: EzchaDatastoresAPI = EzchaDatastoresAPI.new(self)

## A wrapper for the games section of the API.
var games: EzchaGamesAPI = EzchaGamesAPI.new(self)

## A wrapper for the general section of the API.
var general: EzchaGeneralAPI = EzchaGeneralAPI.new(self)

## A wrapper for the leaderboards section of the API.
var leaderboards: EzchaLeaderboardsAPI = EzchaLeaderboardsAPI.new(self)

## A wrapper for the news section of the API.
var news: EzchaNewsAPI = EzchaNewsAPI.new(self)

## A wrapper for the relay section of the API.
var relay: EzchaRelayAPI = EzchaRelayAPI.new(self)

## A wrapper for the sessions section of the API.
var sessions: EzchaSessionsAPI = EzchaSessionsAPI.new(self)

## A wrapper for the trophies section of the API.
var trophies: EzchaTrophiesAPI = EzchaTrophiesAPI.new(self)

## A wrapper for the users section of the API.
var users: EzchaUsersAPI = EzchaUsersAPI.new(self)

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
