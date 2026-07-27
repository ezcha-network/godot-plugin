@tool
extends Node
class_name EzchaSingleton
## The class representing the "Ezcha" singleton.
##
## This is where most of the plugin's functionality is accessed from.

const _HOSTNAME: String = "https://ezcha.net"

static var _instance: EzchaSingleton = null

# API instances

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

## A wrapper for the products section of the API.
var products: EzchaProductsAPI = EzchaProductsAPI.new(self)

## A wrapper for the relay section of the API.
var relay: EzchaRelayAPI = EzchaRelayAPI.new(self)

## A wrapper for the sessions section of the API.
var sessions: EzchaSessionsAPI = EzchaSessionsAPI.new(self)

## A wrapper for the trophies section of the API.
var trophies: EzchaTrophiesAPI = EzchaTrophiesAPI.new(self)

## A wrapper for the users section of the API.
var users: EzchaUsersAPI = EzchaUsersAPI.new(self)

# Lifecycle

func _init() -> void:
	_instance = self

func _exit_tree() -> void:
	if (_instance == self): _instance = null

# Interface

## A helper to return the currently configured game identifier.
func get_game_id() -> String:
	return EzchaOpts._get_setting(EzchaOpts._Setting.GAME_ID)

## A helper to return the currently configured API key.
func get_api_key() -> String:
	return EzchaOpts._get_setting(EzchaOpts._Setting.API_KEY)

## A helper to return the currently configured signing key.
func get_signing_key() -> String:
	return EzchaOpts._get_setting(EzchaOpts._Setting.SIGNING_KEY)

# Internal helpers

static func _get_instance() -> EzchaSingleton:
	return _instance
