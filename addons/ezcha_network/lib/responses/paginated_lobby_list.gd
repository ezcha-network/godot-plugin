extends EzchaPaginatedResponse
class_name EzchaPaginatedLobbyListResponse
## A response from the relay API containing a list of games.

func _get_array_type_map() -> Dictionary:
	return {
		"lobbies": EzchaRelayLobby
	}

## The list of lobbies returned by the API request.
var lobbies: Array[EzchaRelayLobby] = []
