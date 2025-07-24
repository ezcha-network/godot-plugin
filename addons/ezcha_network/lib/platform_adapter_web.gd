extends EzchaPlatformAdapter
class_name EzchaPlatformAdapterWeb
## A class for internal use to handle web specific logic.
##
## You should never need to use this directly.

signal avatar_prompt_completed(success: bool)

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
	var event = args[0]
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	if (event.origin != _ezcha._HOSTNAME): return
	var data = event.data
	match(data.type):
		"session_pending":
			if (!requesting_session_token): return
			session_response_timer = null
		"session_success":
			if (!requesting_session_token): return
			requesting_session_token = false
			auth_flow_completed.emit(data.value)
		"session_error":
			if (!requesting_session_token): return
			requesting_session_token = false
			auth_flow_completed.emit(null)
		"avatar_success":
			avatar_prompt_completed.emit(true)
		"avatar_error":
			avatar_prompt_completed.emit(false)

# Experimental features. These may change in the future.

func login_redirect() -> void:
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "login_redirect"
	window_ref.top.postMessage(data, _ezcha._HOSTNAME)

func avatar_prompt(avatar: Image) -> bool:
	if (avatar.get_width() != 256 || avatar.get_height() != 256):
		printerr("Avatar prompt image must be 256x256 pixels.")
		avatar_prompt_completed.emit(false)
		return false
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	var b64: String = Marshalls.raw_to_base64(avatar.save_png_to_buffer())
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "avatar_prompt"
	data.image = "data:image/png;base64," + b64
	window_ref.top.postMessage(data, _ezcha._HOSTNAME)
	return (await avatar_prompt_completed)
