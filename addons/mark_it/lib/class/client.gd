extends RefCounted
class_name MarkItClient
## A simple client for the language server.

const _CONNECT_TIMEOUT_MSEC: int = 3000
const _REQUEST_TIMEOUT_MSEC: int = 5000
const _HEADER_SEPARATOR: PackedByteArray = [13, 10, 13, 10]

var _stream: StreamPeerTCP = StreamPeerTCP.new()
var _rpc: JSONRPC = JSONRPC.new()
var _tree: SceneTree = null
var _next_id: int = 0
var _buffer: PackedByteArray = PackedByteArray()

func connect_to_server(tree: SceneTree, host: String, port: int) -> Error:
	_tree = tree
	var err: Error = _stream.connect_to_host(host, port)
	if (err != OK): return err
	var start_time: int = Time.get_ticks_msec()
	while (Time.get_ticks_msec() - start_time <= _CONNECT_TIMEOUT_MSEC):
		_stream.poll()
		var status: StreamPeerTCP.Status = _stream.get_status()
		if (status == StreamPeerTCP.STATUS_CONNECTED): return OK
		if (status == StreamPeerTCP.STATUS_ERROR): return ERR_CANT_CONNECT
		await _tree.process_frame
	return ERR_TIMEOUT

func request(method: String, params: Dictionary) -> Variant:
	_next_id += 1
	var id: int = _next_id
	_send(_rpc.make_request(method, params, id))
	var start_time: int = Time.get_ticks_msec()
	while (Time.get_ticks_msec() - start_time <= _REQUEST_TIMEOUT_MSEC):
		var message: Dictionary = _read_message()
		if (message.is_empty()):
			await _tree.process_frame
			continue
		if (int(message.get("id", -1)) == id):
			return message.get("result", null)
	return null

func notify(method: String, params: Dictionary) -> void:
	_send(_rpc.make_notification(method, params))

func close() -> void:
	_stream.disconnect_from_host()

func _send(message: Dictionary) -> void:
	var body: String = JSON.stringify(message)
	var length: int = body.to_utf8_buffer().size()
	var payload: String = "Content-Length: %d\r\n\r\n%s" % [length, body]
	_stream.put_data(payload.to_utf8_buffer())

func _read_message() -> Dictionary:
	_stream.poll()
	var available: int = _stream.get_available_bytes()
	if (available > 0):
		var chunk: Array = _stream.get_data(available)
		if (chunk[0] == OK): _buffer.append_array(chunk[1])
	return _extract_frame()

func _extract_frame() -> Dictionary:
	var header_end: int = _find_header_end()
	if (header_end == -1): return {}
	var header: String = _buffer.slice(0, header_end).get_string_from_utf8()
	var content_length: int = _parse_content_length(header)
	if (content_length < 0):
		_buffer = _buffer.slice(header_end + _HEADER_SEPARATOR.size())
		return {}
	var body_start: int = header_end + _HEADER_SEPARATOR.size()
	if (_buffer.size() < body_start + content_length): return {}
	var body: PackedByteArray = _buffer.slice(body_start, body_start + content_length)
	_buffer = _buffer.slice(body_start + content_length)
	var json: JSON = JSON.new()
	if (json.parse(body.get_string_from_utf8()) != OK): return {}
	var data: Variant = json.get_data()
	return data if data is Dictionary else {}

func _find_header_end() -> int:
	for idx: int in maxi(0, _buffer.size() - 3):
		if (_buffer[idx] == 13 && _buffer[idx + 1] == 10 &&
		_buffer[idx + 2] == 13 && _buffer[idx + 3] == 10):
			return idx
	return -1

func _parse_content_length(header: String) -> int:
	for line: String in header.split("\r\n"):
		if (line.begins_with("Content-Length:")):
			return line.substr("Content-Length:".length()).strip_edges().to_int()
	return -1