extends RefCounted
class_name EzchaResponse
## The base class for handling Ezcha Network API responses.

## Emitted once the response has been received and processed or upon failure.
signal completed()

var _pending: bool = true
var _status_code: int = -1
var _error_msg: String = ""

## (Async) Wait for the request to be completed.
func async() -> EzchaResponse:
	if (_pending): await completed
	return self

## Returns if the response is okay and is not an error.
func is_successful() -> bool:
	return (_status_code >= 200 && _status_code < 300)

## Returns the status code.
func get_status() -> int:
	return _status_code

## Returns the error message if available.
func get_error() -> String:
	return _error_msg

## Returns if the response is pending or not.
func is_pending() -> bool:
	return _pending
