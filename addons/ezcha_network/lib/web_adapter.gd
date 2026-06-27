extends EzchaPlatformAdapter
class_name EzchaWebAdapter
## A class to handle web specific logic.

## Emitted once the avatar prompt is completed.
signal avatar_prompt_completed(success: bool)

## Emitted once the captcha prompt is completed.
signal captcha_prompt_completed(success: bool, response: String)

## Emitted once the rewarded ad prompt is completed.
signal ad_prompt_completed(success: bool, rewarded: bool)

const _RESPONSE_WAIT_TIME: float = 0.2

var _in_prompt: bool = false
var _audio_was_muted: bool = false
var _requesting_session_token: bool = false
var _session_response_timer: SceneTreeTimer = null
var _window_ref: JavaScriptObject = null
var _window_event_ref: JavaScriptObject = null

# Lifecycle

func _init(singleton: EzchaSingleton) -> void:
	super(singleton)
	_window_event_ref = JavaScriptBridge.create_callback(_on_window_message_event)
	_window_ref = JavaScriptBridge.get_interface("window")
	_window_ref.addEventListener("message", _window_event_ref)

# Adapter

func _start_auth_flow() -> void:
	if (_requesting_session_token): return
	_requesting_session_token = true
	_session_response_timer = _ezcha.get_tree().create_timer(_RESPONSE_WAIT_TIME)
	_session_response_timer.timeout.connect(_session_timeout)
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "session_request"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

func _session_timeout() -> void:
	if (_requesting_session_token): return
	_requesting_session_token = false
	auth_flow_completed.emit("")

func _on_window_message_event(args: Array) -> void:
	var event = args[0]
	if (event.origin != _ezcha._HOSTNAME): return
	var data = event.data
	match(data.type):
		"session_pending":
			if (!_requesting_session_token): return
			_session_response_timer = null
		"session_response":
			if (!_requesting_session_token): return
			_requesting_session_token = false
			auth_flow_completed.emit("" if data.error else data.token)
		"session_expired":
			session_expired.emit()
		"avatar_prompt_response":
			if (!_in_prompt): return
			avatar_prompt_completed.emit(!data.error)
			_in_prompt = false
		"captcha_prompt_response":
			if (!_in_prompt): return
			captcha_prompt_completed.emit(!data.error, "" if data.error else data.value)
			_in_prompt = false
		"ad_prompt_response":
			if (!_in_prompt): return
			if (!_audio_was_muted): AudioServer.set_bus_mute(0, false)
			ad_prompt_completed.emit(!data.error, data.rewarded)
			_in_prompt = false

# Interface

## Redirects to the register page and back.
func register_redirect() -> void:
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "register_redirect"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

## Redirects to the login page and back.
func login_redirect() -> void:
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "login_redirect"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

## Closes all web embed prompts.
func close_prompts() -> void:
	if (!_in_prompt): return
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "close_prompts"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)

## Prompts the user to change their avatar. The provided image must be 256x256px.
##
## (Async) Returns true if user accepts and the upload is successful.
func avatar_prompt(avatar: Image) -> bool:
	if (_in_prompt): return false
	_in_prompt = true
	if (avatar.get_width() != 256 || avatar.get_height() != 256):
		printerr("Avatar prompt image must be 256x256 pixels.")
		avatar_prompt_completed.emit(false)
		return false
	var b64: String = Marshalls.raw_to_base64(avatar.save_png_to_buffer())
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "avatar_prompt"
	data.image = "data:image/png;base64," + b64
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)
	return (await avatar_prompt_completed)

## Prompts the user to solve a captcha. The response must be validated via the API.
##
## (Async) Returns the response if successful, otherwise an empty string.
func captcha_prompt() -> String:
	if (_in_prompt): return ""
	_in_prompt = true
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "captcha_prompt"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)
	return (await captcha_prompt_completed)[1]

## Shows the user an interstitial video advertisment.
##
## (Async) Returns the true if an advertisment was displayed.
func interstitial_ad_prompt() -> bool:
	if (_in_prompt): false
	_in_prompt = true
	_audio_was_muted = AudioServer.is_bus_mute(0)
	if (!_audio_was_muted): AudioServer.set_bus_mute(0, true)
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "ad_prompt"
	data.kind = "interstitial"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)
	return (await ad_prompt_completed)[1]

## Shows the user a rewarded video advertisment.
##
## (Async) Returns the true if the player should be rewarded.
func rewarded_ad_prompt() -> bool:
	if (_in_prompt): false
	_in_prompt = true
	_audio_was_muted = AudioServer.is_bus_mute(0)
	if (!_audio_was_muted): AudioServer.set_bus_mute(0, true)
	var data: Variant = JavaScriptBridge.create_object("Object")
	data.type = "ad_prompt"
	data.kind = "rewarded"
	_window_ref.top.postMessage(data, _ezcha._HOSTNAME)
	return (await ad_prompt_completed)[1]
