extends EzchaResponse
class_name EzchaRelayLobbyResponse
## A response from the API containing a single relay lobby.

func _get_type_map() -> Dictionary:
	return {
		"lobby": EzchaRelayLobby
	}

## The lobby returned by the API request.
var lobby: EzchaRelayLobby = null
