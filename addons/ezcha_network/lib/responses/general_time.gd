extends EzchaResponse
class_name EzchaGeneralTimeResponse
## A response from the API containing the current time.

## The server's current time as an ISO 8601 datestring.
var timestamp: String = ""

## The server's current time as a unix epoch measured in milliseconds.
var epoch: int = -1
