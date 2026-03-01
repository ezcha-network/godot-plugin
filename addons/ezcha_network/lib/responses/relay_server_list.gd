extends EzchaResponse
class_name EzchaRelayServerListResponse
## A response from the API containing a list of available relay servers.

func _get_array_type_map() -> Dictionary:
	return {
		"servers": EzchaRelayServer
	}

## The list of relay servers returned by the API request.
var servers: Array[EzchaRelayServer] = []

## The country codes of available relay servers.
var countries: Array[String] = []
