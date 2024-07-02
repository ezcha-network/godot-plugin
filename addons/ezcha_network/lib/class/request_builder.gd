extends Reference
class_name EzchaRequestBuilder
## A class for building and making requests to the Ezcha Network API.

const _USER_AGENT: String = "User-Agent: EzchaNetworkSDK/1.0 Godot4"

var _method: int = HTTPClient.METHOD_GET
var _endpoint: String = ""
var _auth_token: String = ""
var _query_parameters: Dictionary = {}
var _body_data: Dictionary = {}
var _signing_key: String = ""
var _http_req: HTTPRequest = null
var _response_object: EzchaResponse = null

## Sets the target endpoint.
func set_endpoint(value: String) -> EzchaRequestBuilder:
	_endpoint = value
	return self

## Sets the method to be used.
## You should use the HTTPClient.Method enums
func set_method(value: int) -> EzchaRequestBuilder:
	_method = value
	return self

## Sets the authentication header for the request.
func set_authentication(token: String) -> EzchaRequestBuilder:
	_auth_token = token
	return self

## Enables request signing and defines the signing key to use.
## Requires authentication to be set to a session token.
func set_signing_key(key: String) -> EzchaRequestBuilder:
	_signing_key = key
	return self

## Set the response object.
func set_response_object(obj: EzchaResponse) -> EzchaRequestBuilder:
	_response_object = obj
	return self

## Adds a parameter to the query string.
## The value should either be a string or an array of strings.
func add_query_parameter(key: String, value) -> EzchaRequestBuilder:
	if (value == null || (value is String && value == "")): return self
	_query_parameters[key] = value
	return self

## Adds a value to the body data.
func add_body_data(key: String, value) -> EzchaRequestBuilder:
	if (value == null || (value is String && value == "")): return self
	_body_data[key] = value
	return self

func _stringify_values(value, progress:  = PoolStringArray()) -> PoolStringArray:
	match typeof(value):
		TYPE_ARRAY:
			for item in value:
				progress.append_array(_stringify_values(item))
		TYPE_DICTIONARY:
			for key in value.keys():
				progress.append_array(_stringify_values(value[key]))
		TYPE_STRING:
			progress.append(value)
		_:
			progress.append(str(value))
	return progress

## Makes the request.
func fetch() -> void:
	# Generate headers
	var headers: PoolStringArray = PoolStringArray()
	headers.append(_USER_AGENT)
	if (_auth_token != ""): headers.append("Authorization: Bearer " + _auth_token)
	
	# Signing
	if (_signing_key != "" && _auth_token != ""):
		var sign_split: PoolStringArray = _signing_key.split(".", false, 2)
		var auth_split: PoolStringArray = _auth_token.split(".", false, 2)
		if (sign_split.size() != 2 || auth_split.size() != 2):
			printerr("Cannot sign request! Invalid signing key or auth token.")
		else:
			# Add timestamp to body
			_body_data["timestamp"] = Time.get_datetime_string_from_system(true, false) + "Z"
			# Generate signature
			var value_list: PoolStringArray = _stringify_values(_body_data)
			var value_list_str: String = ",".join(value_list)
			var hash_value: String = "%s:%s:%s" % [sign_split[1], auth_split[0], value_list_str]
			var hash_str: String = hash_value.md5_text()
			var base64_value: String = "%s:%s" % [sign_split[0], hash_str]
			var signature: String = Marshalls.utf8_to_base64(base64_value)
			_body_data["signature"] = signature
	
	# Prepare parameters
	var query_str: String = ""
	if (_query_parameters.size() > 0):
		var parts: PoolStringArray = PoolStringArray()
		for key in _query_parameters.keys():
			var value = _query_parameters[key]
			match typeof(value):
				TYPE_STRING:
					parts.append("%s=%s" % [key.http_escape(), value.http_escape()])
				TYPE_ARRAY:
					for item in value:
						parts.append("%s=%s" % [key.http_escape(), str(item).http_escape()])
				TYPE_STRING_ARRAY:
					for item in value:
						parts.append("%s=%s" % [key.uri_encode(), item.uri_encode()])
				_:
					parts.append("%s=%s" % [key.http_escape(), str(value).http_escape()])
		query_str = "?" + "&".join(parts)
	
	# Prepare body
	var body_str: String = ""
	if (_body_data.size() > 0):
		headers.append("Content-Type: application/json")
		body_str = JSON.print(_body_data, "", false)
	
	# Make the request node
	var _ezcha: Node = Engine.get_main_loop().root.get_node("Ezcha")
	var final_url: String = _ezcha._HOSTNAME_API + _endpoint + query_str
	_http_req = HTTPRequest.new()
	_ezcha.add_child(_http_req)
	_http_req.use_threads = (OS.get_name() != "HTML5")
	_http_req.connect("request_completed", self, "_on_request_completed")
	reference()
	_http_req.request(final_url, headers, true, _method, body_str)

func _all_done() -> void:
	if (_response_object != null):
		_response_object._pending = false
		_response_object.emit_signal("recieved", _response_object)
	if (_http_req != null):
		_http_req.queue_free()
	unreference()

func _on_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if (_response_object == null):
		_all_done()
		return
	_response_object._status_code = response_code
	
	# Parse the response
	var json: JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if (json.error != OK):
		_all_done()
		return
	
	if (!_response_object.is_successful()):
		if (json.result is Dictionary && json.result.has("message")):
			if (OS.is_debug_build()):
				printerr("Ezcha Network API error!\nEndpoint: %s\nStatus code: %s\nMessage: %s" % [
				_endpoint,
				str(response_code),
				json.result["message"]
			])
			_response_object._error_msg = json.result["message"]
		elif (OS.is_debug_build()):
			printerr("Ezcha Network API error!\nEndpoint: %s\nStatus code: %s" % [
				_endpoint,
				str(response_code)
			])
		_all_done()
		return
	
	_response_object._unpack_data(json.result)
	_all_done()