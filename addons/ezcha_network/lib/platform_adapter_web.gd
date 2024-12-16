extends EzchaPlatformAdapter
class_name EzchaPlatformAdapterWeb
## A class for internal use to handle web specific logic.
##
## You should never need to use this directly.

const RESPONSE_WAIT_TIME: float = 0.2

var requesting_session_token: bool = false
var session_response_timer: SceneTreeTimer = null
var window_ref: JavaScriptObject = null
var window_event_ref: JavaScriptObject = null

func _init() -> void:
	window_event_ref = JavaScriptBridge.create_callback(_on_window_message_event)
	window_ref = JavaScriptBridge.get_interface("window")
	window_ref.addEventListener("message", window_event_ref)

func _start_auth_flow() -> void:
	if (requesting_session_token): return
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	requesting_session_token = true
	session_response_timer = _ezcha.get_tree().create_timer(RESPONSE_WAIT_TIME)
	session_response_timer.timeout.connect(_session_timeout)
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "session_request"
	window_ref.top.postMessage(data, _ezcha._HOSTNAME)

func _session_timeout() -> void:
	if (requesting_session_token): return
	requesting_session_token = false
	auth_flow_completed.emit(null)

func _on_window_message_event(args: Array) -> void:
	if (!requesting_session_token): return
	var event = args[0]
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	if (event.origin != _ezcha._HOSTNAME): return
	var data = event.data
	match(data.type):
		"session_pending":
			session_response_timer = null
		"session_success":
			requesting_session_token = false
			auth_flow_completed.emit(data.value)
		"session_error":
			requesting_session_token = false
			auth_flow_completed.emit(null)
