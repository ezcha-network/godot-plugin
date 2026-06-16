extends EzchaDto
class_name EzchaRelayLobby

func _get_type_map() -> Dictionary:
	return {
		"host": EzchaUser,
		"server": EzchaRelayServer
	}

## The UUID of the lobby.
var id: String = ""

## The 6 character join code of the lobby.
var join_code: String = ""

## The name of the lobby.
var name: String = ""

## The game version the lobby supports.
var version: String = ""

## The game mode the lobby currently is in.
var game_mode: int = -1

## The current player count.
var player_count = -1

## The lobby's player limit.
var player_limit = -1

## A timestamp of when the lobby was created.
var created_at: String = ""

## The current host of the lobby.
var host: EzchaUser = null

## The server which the lobby is hosted on.
var server: EzchaRelayServer = null

## Check if two instances represent the same lobby.
## Data can vary if requested at different times.
func equals(other: EzchaRelayLobby) -> bool:
	return (id == other.id)
