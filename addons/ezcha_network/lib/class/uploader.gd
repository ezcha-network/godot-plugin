extends RefCounted
class_name EzchaUploader
## A class that manages a file upload stream over HTTPS.

## Emitted as the upload progresses.
signal progress(fraction: float)

const _USER_AGENT: String = "EzchaNetworkSDK/1.0 Godot4"
const _CHUNK_SIZE: int = 65536
const _FRAME_BUDGET_MS: int = 15

class _UploadFile extends RefCounted:
	var _field: String = ""
	var _type: String = ""
	var _path: String = ""
	var _size: int = 0
	var _header: PackedByteArray = PackedByteArray()
	func _init(field: String, type: String, path: String) -> void:
		_field = field
		_type = type
		_path = path

var _hostname: String = "api.ezcha.net"
var _port: int = 443
var _endpoint: String = ""
var _auth_token: String = ""
var _query_parameters: Dictionary[String, Variant] = {}
var _files: Array[_UploadFile] = []
var _timeout: float = 120.0
var _response_object: EzchaResponse = null

# Interface

## Sets the target hostname.
func set_hostname(value: String) -> EzchaUploader:
	_hostname = value
	return self

## Sets the target port.
func set_port(value: int) -> EzchaUploader:
	_port = value
	return self

## Sets the target endpoint.
func set_endpoint(value: String) -> EzchaUploader:
	_endpoint = value
	return self

## Sets the authentication header.
func set_authentication(token: String) -> EzchaUploader:
	_auth_token = token
	return self

## Adds a file to the upload.
func add_file(field: String, type: String, path: String) -> EzchaUploader:
	_files.append(_UploadFile.new(field, type, path))
	return self

## Sets the upload timeout.
func set_timeout(time: float) -> EzchaUploader:
	_timeout = time
	return self

## Adds a callback function to be called when the upload progresses.
func add_progress_callback(cb: Callable) -> EzchaUploader:
	progress.connect(cb)
	return self

## Set the response object.
func set_response_object(obj: EzchaResponse) -> EzchaUploader:
	_response_object = obj
	return self

## Adds a parameter to the query string.
func add_query_parameter(key: String, value: Variant) -> EzchaUploader:
	if (value == null || (value is String && value.is_empty())): return self
	_query_parameters[key] = value
	return self

## Starts the upload and returns the response object to await.
func start() -> EzchaResponse:
	if (_response_object == null): _response_object = EzchaResponse.new()
	# Don't dispose until the upload is completed
	reference()
	_run.call_deferred()
	return _response_object

# Internal helpers

func _run() -> void:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if (tree == null): return _fail("No SceneTree available to drive the upload.")
	if (_files.is_empty()): return _fail("No files added to the upload.")
	
	# Build multipart headers and calculate content length
	var boundary: String = "Boundary%d" % [Time.get_ticks_usec()]
	var content_length: int = 0
	var total_file_bytes: int = 0
	for entry: _UploadFile in _files:
		var file: FileAccess = FileAccess.open(entry._path, FileAccess.READ)
		if (file == null): return _fail("Failed to open the file at \"%s\"." % [entry._path])
		entry._size = file.get_length()
		file.close()
		entry._header = (
			"--%s\r\nContent-Disposition: form-data; name=\"%s\"; filename=\"%s\"\r\nContent-Type: %s\r\n\r\n" % [
				boundary, entry._field, entry._path.get_file(), entry._type
			]
		).to_utf8_buffer()
		content_length += entry._header.size() + entry._size + 2
		total_file_bytes += entry._size
	var closing: PackedByteArray = ("--%s--\r\n" % [boundary]).to_utf8_buffer()
	content_length += closing.size()
	
	var request_head: String = "POST %s%s HTTP/1.1\r\n" % [_endpoint, _build_query()]
	request_head += "Host: %s\r\n" % [_hostname]
	request_head += "User-Agent: %s\r\n" % [_USER_AGENT]
	if (!_auth_token.is_empty()): request_head += "Authorization: Bearer %s\r\n" % [_auth_token]
	request_head += "Content-Type: multipart/form-data; boundary=%s\r\n" % [boundary]
	request_head += "Content-Length: %d\r\n" % [content_length]
	request_head += "Connection: close\r\n\r\n"
	
	# Connect
	var deadline: int = Time.get_ticks_msec() + int(_timeout * 1000.0)
	var tcp: StreamPeerTCP = StreamPeerTCP.new()
	if (tcp.connect_to_host(_hostname, _port) != OK):
		return _fail("Failed to start connection to %s." % [_hostname])
	while (tcp.get_status() == StreamPeerTCP.STATUS_CONNECTING):
		tcp.poll()
		if (Time.get_ticks_msec() > deadline): break
		await tree.process_frame
	if (tcp.get_status() != StreamPeerTCP.STATUS_CONNECTED):
		return _fail("Could not connect to %s." % [_hostname])
	tcp.set_no_delay(true)
	
	# TLS handshake
	var tls: StreamPeerTLS = StreamPeerTLS.new()
	if (tls.connect_to_stream(tcp, _hostname, TLSOptions.client()) != OK):
		return _fail("Failed to start the TLS handshake.")
	while (tls.get_status() == StreamPeerTLS.STATUS_HANDSHAKING):
		tls.poll()
		if (Time.get_ticks_msec() > deadline): break
		await tree.process_frame
	if (tls.get_status() != StreamPeerTLS.STATUS_CONNECTED):
		return _fail("TLS handshake failed.")
	
	# Send request header
	if (tls.put_data(request_head.to_utf8_buffer()) != OK):
		return _fail("Failed to send the request header.")
	
	# Stream each file part
	progress.emit(0.0)
	var bytes_sent: int = 0
	var frame_start: int = Time.get_ticks_msec()
	for entry: _UploadFile in _files:
		if (tls.put_data(entry._header) != OK):
			return _fail("Failed to send a part header.")
		var file: FileAccess = FileAccess.open(entry._path, FileAccess.READ)
		if (file == null): return _fail("Failed to reopen the file at \"%s\"." % [entry._path])
		while (file.get_position() < entry._size):
			var chunk: PackedByteArray = file.get_buffer(_CHUNK_SIZE)
			if (tls.put_data(chunk) != OK):
				file.close()
				return _fail("Connection lost during upload.")
			tls.poll()
			bytes_sent += chunk.size()
			progress.emit(float(bytes_sent) / float(total_file_bytes))
			if (Time.get_ticks_msec() - frame_start >= _FRAME_BUDGET_MS):
				await tree.process_frame
				frame_start = Time.get_ticks_msec()
		file.close()
		if (tls.put_data("\r\n".to_utf8_buffer()) != OK):
			return _fail("Failed to finalize a part.")
	
	if (tls.put_data(closing) != OK): return _fail("Failed to finalize the upload.")
	progress.emit(1.0)
	
	# Read the response
	var response: PackedByteArray = PackedByteArray()
	var body_start: int = -1
	var body_length: int = -1
	deadline = Time.get_ticks_msec() + int(_timeout * 1000.0)
	while (true):
		if (tls.get_status() == StreamPeerTLS.STATUS_CONNECTED): tls.poll()
		var available: int = tls.get_available_bytes() if (tls.get_status() == StreamPeerTLS.STATUS_CONNECTED) else 0
		if (available > 0):
			var got: Array = tls.get_partial_data(available)
			if (got[0] == OK): response.append_array(got[1])
		
		# Determine body length once the headers are in
		if (body_start == -1):
			body_start = _find_header_end(response)
			if (body_start != -1):
				body_length = _content_length(response.slice(0, body_start - 4).get_string_from_utf8())
		
		# Stop once the full body has been received
		if (body_start != -1 && body_length >= 0 && response.size() >= body_start + body_length):
			break
		
		# Detect when the connection closes
		if (tls.get_status() != StreamPeerTLS.STATUS_CONNECTED && available == 0):
			break
		
		# Detect timeout
		if (Time.get_ticks_msec() > deadline): return _fail("Timed out waiting for a response.")
		if (available == 0): await tree.process_frame
	
	_handle_response(response)

func _build_query() -> String:
	if (_query_parameters.is_empty()): return ""
	var parts: PackedStringArray = PackedStringArray()
	for key: String in _query_parameters.keys():
		var value: Variant = _query_parameters[key]
		var value_str: String = ""
		match typeof(value):
			TYPE_BOOL: value_str = "true" if value else "false"
			TYPE_STRING: value_str = value
			_: value_str = str(value)
		parts.append("%s=%s" % [key.uri_encode(), value_str.uri_encode()])
	return "?" + "&".join(parts)

func _find_header_end(data: PackedByteArray) -> int:
	for idx: int in maxi(0, data.size() - 3):
		if (data[idx] == 13 && data[idx + 1] == 10 && data[idx + 2] == 13 && data[idx + 3] == 10):
			return idx + 4
	return -1

func _content_length(headers: String) -> int:
	for line: String in headers.split("\r\n", false):
		if (!line.to_lower().begins_with("content-length:")): continue
		return line.split(":", false, 1)[1].strip_edges().to_int()
	return -1

func _handle_response(response: PackedByteArray) -> void:
	# Parse response data
	var text: String = response.get_string_from_utf8()
	var response_code: int = 0
	var first_line_end: int = text.find("\r\n")
	if (first_line_end != -1):
		var parts: PackedStringArray = text.substr(0, first_line_end).split(" ", false)
		if (parts.size() >= 2): response_code = parts[1].to_int()
	_response_object._status_code = response_code
	
	# Determine if JSON response
	var header_split: int = text.find("\r\n\r\n")
	var body: String = text.substr(header_split + 4) if (header_split != -1) else text
	var likely_json: bool = (body.find("{") != -1 && body.rfind("}") != -1)
	
	# Parse response
	var json: Variant = null
	if (likely_json):
		json = JSON.parse_string(body)
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

func _fail(message: String) -> void:
	if (_response_object != null):
		if (_response_object._status_code < 0): _response_object._status_code = 0
		_response_object._error_msg = message
	if (EzchaOpts._should_print_request_errors()):
		printerr(EzchaOpts._PRINT_PREFIX + "Upload failed.\n%s" % [message])
	_all_done()

func _all_done() -> void:
	if (_response_object != null):
		_response_object._pending = false
		_response_object.completed.emit()
	# Ready for disposal
	unreference()
