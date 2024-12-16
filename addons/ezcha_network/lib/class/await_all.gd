extends RefCounted
class_name EzchaAwaitAll
## A helper class to conveniently monitor multiple async coroutines.
##
## Emits a signal once all provided coroutines have completed.
## Provides its own async function that can be used to block execution.

## Emitted once all coroutines have completed.
signal completed

var _expected: int = 0
var _completed: int = 0

## Add a coroutine to be watched
func add(target: Callable, args: Array[Variant]) -> void:
	_expected += 1
	await target.callv(args)
	_completed += 1
	if (_completed < _expected): return
	completed.emit()

## Returns how many coroutines are being watched
func count() -> int:
	return _expected

## (Async) Blocks execution until all coroutines complete
func block() -> void:
	if (_expected == 0 || _completed >= _expected): return
	await completed
