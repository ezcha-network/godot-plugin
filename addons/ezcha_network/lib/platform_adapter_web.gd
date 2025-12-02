extends EzchaPlatformAdapter
class_name EzchaPlatformAdapterWeb
## A class to handle web specific logic.

## Emitted once the avatar prompt is completed.
signal avatar_prompt_completed(success: bool)

## Emitted once the captcha prompt is completed.
signal captcha_prompt_completed(success: bool, response: String)

const _RESPONSE_WAIT_TIME: float = 0.2

var _in_prompt: bool = false
var _requesting_session_token: bool = false
var _session_response_timer: SceneTreeTimer = null
var _window_ref: JavaScriptObject = null
var _window_event_ref: JavaScriptObject = null
var _captcha_response: String = ""

func _init() -> void:
	_window_event_ref = JavaScriptBridge.create_callback(_on_window_message_event)
	_window_ref = JavaScriptBridge.get_interface("window")
	_window_ref.addEventListener("message", _window_event_ref)

func _start_auth_flow() -> void:
	if (_requesting_session_token): return
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	_requesting_session_token = true
	_session_response_timer = _ezcha.get_tree().create_timer(_RESPONSE_WAIT_TIME)
	_session_response_timer.timeout.connect(_session_timeout)
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "session_request"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

func _session_timeout() -> void:
	if (_requesting_session_token): return
	_requesting_session_token = false
	auth_flow_completed.emit(null)

func _on_window_message_event(args: Array) -> void:
	var event = args[0]
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	if (event.origin != _ezcha._HOSTNAME): return
	var data = event.data
	match(data.type):
		"session_pending":
			if (!_requesting_session_token): return
			_session_response_timer = null
		"session_success":
			if (!_requesting_session_token): return
			_requesting_session_token = false
			auth_flow_completed.emit(data.value)
		"session_error":
			if (!_requesting_session_token): return
			_requesting_session_token = false
			auth_flow_completed.emit(null)
		"avatar_success":
			if (!_in_prompt): return
			avatar_prompt_completed.emit(true)
			_in_prompt = false
		"avatar_error":
			if (!_in_prompt): return
			avatar_prompt_completed.emit(false)
			_in_prompt = false
		"captcha_success":
			if (!_in_prompt): return
			_captcha_response = data.value
			captcha_prompt_completed.emit(true, data.value)
			_in_prompt = false
		"captcha_error":
			if (!_in_prompt): return
			_captcha_response = ""
			captcha_prompt_completed.emit(false, "")
			_in_prompt = false

## (Experimental)
## Redirects to the login page and back.
func login_redirect() -> void:
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "login_redirect"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

## (Experimental) Closes all web container prompts.
func close_prompts() -> void:
	if (!_in_prompt): return
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "close_prompts"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

## (Experimental)
## Prompts the user to change their avatar. The provided image must be 256x256px.
## (Async) Returns true if user accepts and the upload is successful.
func avatar_prompt(avatar: Image) -> bool:
	if (_in_prompt): return false
	_in_prompt = true
	if (avatar.get_width() != 256 || avatar.get_height() != 256):
		printerr("Avatar prompt image must be 256x256 pixels.")
		avatar_prompt_completed.emit(false)
		return false
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	var b64: String = Marshalls.raw_to_base64(avatar.save_png_to_buffer())
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "avatar_prompt"
	data.image = "data:image/png;base64," + b64
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)
	return (await avatar_prompt_completed)

## (Experimental)
## Prompts the user to solve a captcha. The response must be validated via the API.
## (Async) Returns the response if successful, otherwise an empty string.
func captcha_prompt() -> String:
	if (_in_prompt): return ""
	_in_prompt = true
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "captcha_prompt"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)
	await captcha_prompt_completed
	return _captcha_response
