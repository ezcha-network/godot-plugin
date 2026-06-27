extends RefCounted
class_name EzchaRequestBuilder
## A class for building and making requests to the Ezcha Network API.

const _USER_AGENT: String = "User-Agent: EzchaNetworkSDK/1.0 Godot4"

var _method: HTTPClient.Method = HTTPClient.METHOD_GET
var _hostname: String = "api.ezcha.net"
var _endpoint: String = ""
var _auth_token: String = ""
var _query_parameters: Dictionary[String, Variant] = {}
var _body_data: Dictionary[String, Variant] = {}
var _signing_key: String = ""
var _parse_response: bool = true
var _http_req: HTTPRequest = null
var _response_object: EzchaResponse = null
var _timeout: float = 10.0

# Interface

## Sets the target hostname.
func set_hostname(value: String) -> EzchaRequestBuilder:
	_hostname = value
	return self

## Sets the target endpoint.
func set_endpoint(value: String) -> EzchaRequestBuilder:
	_endpoint = value
	return self

## Sets the method to be used.
func set_method(value: HTTPClient.Method) -> EzchaRequestBuilder:
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

## Enable/disable response parsing for performance.
func set_parse_response(enabled: bool) -> EzchaRequestBuilder:
	_parse_response = enabled
	return self

## Set the response object.
func set_response_object(obj: EzchaResponse) -> EzchaRequestBuilder:
	_response_object = obj
	return self

## Set the request timeout. Defaults to 10 seconds.
func set_timeout(time: float) -> EzchaRequestBuilder:
	_timeout = time
	return self

## Adds a parameter to the query string.
## The value should either be a string or an array of strings.
func add_query_parameter(key: String, value: Variant) -> EzchaRequestBuilder:
	if (value == null || (value is String && value.is_empty())): return self
	_query_parameters[key] = value
	return self

## Adds a value to the body data.
func add_body_data(key: String, value: Variant) -> EzchaRequestBuilder:
	if (value == null || (value is String && value.is_empty())): return self
	_body_data[key] = value
	return self

## Makes the request.
func fetch() -> EzchaResponse:
	# Generate headers
	var headers: PackedStringArray = PackedStringArray()
	headers.append(_USER_AGENT)
	if (_auth_token != ""): headers.append("Authorization: Bearer " + _auth_token)
	
	# Signing
	if (_signing_key != "" && _auth_token != ""):
		var sign_split: PackedStringArray = _signing_key.split(".", false, 2)
		var auth_split: PackedStringArray = _auth_token.split(".", false, 2)
		if (sign_split.size() != 2 || auth_split.size() != 2):
			printerr("Cannot sign request! Invalid signing key or auth token.")
		else:
			# Add timestamp to body
			_body_data["timestamp"] = Time.get_datetime_string_from_system(true, false) + "Z"
			# Generate signature
			var value_list: PackedStringArray = _stringify_values(_body_data)
			var value_list_str: String = ",".join(value_list)
			var hash_value: String = "%s:%s:%s" % [sign_split[1], auth_split[0], value_list_str]
			var hash: String = hash_value.md5_text()
			var base64_value: String = "%s:%s" % [sign_split[0], hash]
			var signature: String = Marshalls.utf8_to_base64(base64_value)
			_body_data["signature"] = signature
	
	# Prepare parameters
	var query_str: String = ""
	if (_query_parameters.size() > 0):
		var parts: PackedStringArray = PackedStringArray()
		for key: String in _query_parameters.keys():
			var value: Variant = _query_parameters[key]
			if (value is Array || value is PackedStringArray):
				for item: Variant in value:
					parts.append("%s=%s" % [key.uri_encode(), str(item).uri_encode()])
				continue
			parts.append("%s=%s" % [key.uri_encode(), str(value).uri_encode()])
		query_str = "?" + "&".join(parts)
	
	# Prepare body
	var body_str: String = ""
	if (!_body_data.is_empty()):
		headers.append("Content-Type: application/json")
		body_str = JSON.stringify(_body_data, "", false, false)
	
	# Prepare response object if none defined
	if (_response_object == null):
		_response_object = EzchaResponse.new()
	
	# Don't dispose until the request is completed
	reference()
	
	# Prepare the request node
	var _ezcha: EzchaSingleton = EzchaSingleton._get_instance()
	_http_req = HTTPRequest.new()
	_http_req.timeout = _timeout
	_http_req.use_threads = (OS.get_name() != "Web")
	_http_req.request_completed.connect(_on_request_completed)
	_ezcha.add_child(_http_req)
	
	# Send request
	var final_url: String = "https://%s%s%s" % [_hostname, _endpoint, query_str]
	_http_req.request.call_deferred(final_url, headers, _method, body_str)
	return _response_object

# Internal helpers

func _stringify_values(value: Variant, progress: PackedStringArray = PackedStringArray()) -> PackedStringArray:
	match typeof(value):
		TYPE_ARRAY:
			for item: Variant in value:
				progress.append_array(_stringify_values(item))
		TYPE_DICTIONARY:
			for key: Variant in value.keys():
				progress.append_array(_stringify_values(value[key]))
		TYPE_STRING:
			progress.append(value)
		_:
			progress.append(str(value))
	return progress

func _all_done() -> void:
	if (_response_object != null):
		_response_object._pending = false
		_response_object.completed.emit()
	if (_http_req != null):
		_http_req.queue_free()
	# Ready for disposal
	unreference()

func _on_request_completed(_result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if (_response_object == null): return _all_done()
	_response_object._status_code = response_code
	
	# Determine if JSON response
	var body_str: String = body.get_string_from_utf8()
	var likely_json: bool = (body_str.find("{") != -1 && body_str.rfind("}") != -1)
	
	# Parse response
	var json: Variant = null
	if (likely_json):
		json = JSON.parse_string(body_str)
		if (json == null): printerr(EzchaOpts._PRINT_PREFIX + "Failed to parse JSON response.")
		else: EzchaUtil.unpack_data(_response_object, json)
	
	# Handle errors
	if (_response_object.is_successful()): return _all_done()
	if (!EzchaOpts._should_print_request_errors()): return _all_done()
	if (json != null && json.has("message")):
		printerr(
			EzchaOpts._PRINT_PREFIX + "API error.\nEndpoint: %s\nStatus code: %s\nMessage: %s" % [
				_endpoint,
				str(response_code),
				json["message"]
			]
		)
	else:
		printerr(EzchaOpts._PRINT_PREFIX + "API error.\nEndpoint: %s\nStatus code: %s" % [
			_endpoint,
			str(response_code)
		])
	_all_done()
