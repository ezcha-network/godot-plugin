extends EzchaDto
class_name EzchaRelayServer

## The server's unique identifier.
var id: String = ""

## The user friendly name of the region.
var name: String = ""

## The region the server is in.
var region: String = ""

## The address of the relay server.
var address: String = ""

## Whether or not the server is elite exclusive.
var elite_exclusive: bool = false

## The cached lobby count.
var lobby_count: int = -1

## The cached player count.
var player_count = -1

## Attempt to ping the server.
## (Async) Returns the time spent in milliseconds or -1 if failed.
func ping() -> int:
	var res: EzchaResponse = EzchaResponse.new()
	var req: EzchaRequestBuilder = EzchaRequestBuilder.new()\
		.set_hostname(address)\
		.set_method(HTTPClient.METHOD_GET)\
		.set_parse_response(false)\
		.set_response_object(res)\
		.set_timeout(3.0)
	var start_ms: int = Time.get_ticks_msec()
	req.fetch()
	await res.completed
	if (!res.is_successful()): return -1
	return Time.get_ticks_msec() - start_ms
