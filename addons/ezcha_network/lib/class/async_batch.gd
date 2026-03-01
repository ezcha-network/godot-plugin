extends RefCounted
class_name EzchaAsyncBatch
## A helper class to batch and watch multiple asynchronous coroutines.
##
## Tracks return values and emits a signal once all coroutines have completed.
## Provides its own async function that can be used to block execution.

## Emitted once all coroutines have completed.
signal completed(results: Array[Variant])

enum _State {
	PREPARING = 0,
	PROCESSING = 1,
	COMPLETED = 2
}

var _state: _State = _State.PREPARING
var _results: Array[Variant] = []
var _pending: Array[Callable] = []
var _total_count: int = 0
var _completed_count: int = 0

## Add a coroutine to the batch.
func add(coroutine: Callable, args: Array[Variant] = []) -> void:
	if (_state != _State.PREPARING):
		push_error("AsyncBatch: Cannot add coroutines once watched.")
		return
	_results.append(null)
	_pending.append(coroutine.bindv(args))
	_total_count += 1

## Returns how many coroutines have been added.
func count() -> int:
	return _total_count

## Returns how many coroutines are still pending.
func count_pending() -> int:
	return _total_count - _completed_count

## Returns how many coroutines have been completed.
func count_completed() -> int:
	return _completed_count

## Returns true if all coroutines have completed.
func is_completed() -> bool:
	return (_state == _State.COMPLETED)

## Returns true if any coroutines are processing.
func is_processing() -> bool:
	return (_state == _State.PROCESSING)

## Returns the values returned from the coroutines.
## A value will be null if the coroutine is either pending or void.
## These will be in the same order as the corresponding coroutines were added.
func get_results() -> Array[Variant]:
	return _results

## Starts and watches all coroutines, waiting until each one is completed.
## (Async) Returns an array of coroutine results in the same order as they were added.
func watch() -> Array[Variant]:
	if (_state != _State.PREPARING):
		push_error("AsyncBatch: Processing has already started.")
		return []
	if (_pending.is_empty()):
		_state = _State.COMPLETED
		completed.emit()
		return []
	_state = _State.PROCESSING
	for idx: int in _pending.size(): _execute(idx, _pending.pop_front())
	await completed
	return _results

func _execute(index: int, coroutine: Callable) -> void:
	_results[index] = await coroutine.call()
	_completed_count += 1
	if (_completed_count != _total_count): return
	_state = _State.COMPLETED
	completed.emit(_results)
