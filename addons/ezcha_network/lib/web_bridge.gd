extends Object
class_name EzchaWebBridge
## A class for internal use to help manage communication with the Ezcha website.
##
## You should never need to use this directly.

const _RESPONSE_WAIT_TIME: float = 0.2

## (token: Variant)
signal _session_token_response

var _requesting_session_token: bool = false
var _session_response_timer: SceneTreeTimer = null
var _window_ref: JavaScriptObject = null
var _window_event_ref: JavaScriptObject = null

func _init() -> void:
	if (OS.get_name() != "HTML5"): return
	_window_event_ref = JavaScript.create_callback(self, "_on_window_message_event")
	_window_ref = JavaScript.get_interface("window")
	_window_ref.addEventListener("message", _window_event_ref)

func _request_session_token() -> void:
	if (_requesting_session_token): return
	_requesting_session_token = true
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	_session_response_timer = _ezcha.get_tree().create_timer(_RESPONSE_WAIT_TIME)
	_session_response_timer.connect("timeout", self, "_session_timeout")
	var data = JavaScript.create_object("Object")
	data.type = "session_request"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

func _session_timeout() -> void:
	if (_requesting_session_token): return
	_requesting_session_token = false
	emit_signal("_session_token_response", null)

func _on_window_message_event(args: Array) -> void:
	if (!_requesting_session_token): return
	var event = args[0]
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	if (event.origin != _ezcha._HOSTNAME): return
	var data = event.data
	match(data.type):
		"session_pending":
			_session_response_timer = null
		"session_success":
			_requesting_session_token = false
			emit_signal("_session_token_response", data.value)
		"session_error":
			_requesting_session_token = false
			emit_signal("_session_token_response", null)
