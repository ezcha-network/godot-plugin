extends MultiplayerPeerExtension
class_name EzchaRelayMultiplayerPeer
## A lobby based MultiplayerPeer implementation which uses Ezcha Relay for networking.

## Emitted after connecting to a lobby.
signal lobby_connected()

## Emitted after creating a new lobby.
signal lobby_created()

## Emitted after joining an existing lobby.
signal lobby_joined()

## Emitted when a peer joins the lobby.
## Mirrors peer_connected but includes user data and emits upon lobby creation.
signal user_connected(peer_id: int, user: EzchaUser)

## Emitted when a peer leaves the lobby.
## Mirrors peer_disconnected but includes user data.
signal user_disconnected(peer_id: int, user: EzchaUser)

## Emitted when the name of the lobby changes.
signal name_changed(new_name: String)

## Emitted when the current game mode changes.
signal game_mode_changed(new_mode: int)

## Emitted when the player limit changes.
signal player_limit_changed(new_limit: int)

## Emitted when visibility of the lobby changes.
signal visibility_changed(new_visibility: Visibility)

## Emitted when the lobby migrates hosts to a new peer.
signal host_migrated(old_host_id: int, new_host_id: int)

## Emitted when an error occurs during relay operations.
signal error(code: int, message: String)

## Emitted when kicked from the lobby.
signal kicked(message: String)

enum _Serverbound {
	HANDSHAKE = 0x00,
	JOIN_LOBBY = 0x10,
	CREATE_LOBBY = 0x11,
	UPDATE_LOBBY = 0x20,
	CLOSE_LOBBY = 0x21,
	KICK_PEER = 0x22,
	BAN_PEER = 0x23,
	GAME_DATA = 0xF0
}

enum _Clientbound {
	HANDSHAKE = 0x00,
	ASSIGN_ID = 0x10,
	LOBBY_OPTIONS = 0x11,
	ADD_PEER = 0x12,
	REMOVE_PEER = 0x13,
	ERROR = 0xE0,
	GAME_DATA = 0xF0
}

enum _OptionFlag {
	NAME = 0x01,
	GAME_MODE = 0x02,
	MAX_PLAYERS = 0x04,
	VISIBILITY = 0x08,
	REFUSE_CONNECTIONS = 0x10,
	HOST_PEER_ID = 0x20
}

enum ErrorType {
	CLIENT_EXCEPTION = -1,
	INVALID_REQUEST = 100,
	NO_PERMISSION = 101,
	RATE_LIMIT = 102,
	UNSUPPORTED_PROTOCOL = 200,
	AUTH_FAILED = 201,
	SERVER_MAX_CAPACITY = 202,
	LOBBY_NOT_FOUND = 300,
	GAME_ID_MISMATCH = 310,
	VERSION_MISMATCH = 311,
	LOBBY_FULL = 320,
	NOT_FRIENDS = 321, # </3
	REFUSING_CONNECTIONS = 322,
	BANNED = 323,
	LOBBY_LIMIT_REACHED = 400,
	KICKED = 500,
	INVALID_PEER = 501,
	INTERNAL = 900
}

enum Visibility {
	PUBLIC = 0,
	UNLISTED = 1,
	FRIENDS_ONLY = 2
}

enum Operation {
	NONE = 0,
	CONNECT = 1,
	HANDSHAKE = 2,
	CREATE_LOBBY = 3,
	JOIN_LOBBY = 4
}

const _SPAWNER_GROUP: StringName = &"_ezcha_multiplayer_spawner"

const _GODOT_ID_OFFSET: int = 2
const _GODOT_HEADER_SIZE: int = 2
const _INCOMING_HEADER_SIZE: int = 6
const _MAX_TRANSFER_MODE: int = 2
const _MAX_PACKET_SIZE: int = 4096

var _ezcha: EzchaSingleton = null

var _lobby_id: String = ""
var _join_code: String = ""
var _lobby_name: String = ""
var _game_mode: int = -1
var _player_limit: int = -1
var _visibility: Visibility = Visibility.PUBLIC
var _refuse_connections: bool = false

var _ws: WebSocketPeer = null
var _unique_id: int = -1 # Server ID
var _host_id: int = -1 # Server ID
var _peers: Dictionary[int, EzchaUser] = {} # Local ID
var _incoming_packets: Array[EzchaRelayPacket] = []
var _target_peer: int = 0
var _transfer_mode: TransferMode = TRANSFER_MODE_RELIABLE
var _transfer_channel: int = 0

var _operation: Operation = Operation.NONE
var _operation_result: Variant = null
var _initializing: bool = false
var _authenticated: bool = false
var _guest_session: bool = false
var _mock_status: ConnectionStatus = CONNECTION_DISCONNECTED

# Lifecycle

func _init() -> void:
	_ezcha = EzchaSingleton._get_instance()

# Main interface

## Resolve a join code, connect to the relay server, and then join the lobby.
## Do not call this function with `await`.
func resolve_lobby(join_code: String) -> void:
	if (!_prepare_connection()): return
	var resolve_res: EzchaRelayLobbyResponse = await _ezcha.relay.resolve_lobby(_ezcha.get_game_id(), join_code).async()
	if (!resolve_res.is_successful()):
		_handle_connection_failed()
		error.emit(
			ErrorType.LOBBY_NOT_FOUND,
			"Lobby not found." if (resolve_res.get_status() == 404) \
			else "Failed to resolve lobby."
		)
		return
	if (!await _open_connection(resolve_res.lobby.server.address)): return
	await _send_join_request(resolve_res.lobby.id)

## Connect to a relay server and join a lobby.
## Do not call this function with `await`.
func join_lobby(lobby: EzchaRelayLobby) -> void:
	if (!_prepare_connection()): return
	if (!await _open_connection(lobby.server.address)): return
	await _send_join_request(lobby.id)

## Request a new lobby from the relay server.
## Hosting requires the user to be authenticated.
## Do not call this function with `await`.
func create_lobby(server: EzchaRelayServer, name: String, players: int, game_mode: int = 0, visibility: Visibility = Visibility.PUBLIC, host_migration: bool = false) -> void:
	if (!_ezcha.client.is_authenticated()):
		printerr("EzchaRelay: User must be authenticated to host lobbies.")
		error.emit(ErrorType.CLIENT_EXCEPTION, "Authentication required.")
		return
	if (!_prepare_connection()): return
	if (!await _open_connection(server.address)): return
	await _send_create_request(name, players, game_mode, visibility, host_migration)

## Kick another player from the lobby.
## (host/moderator only)
func kick(peer_id: int, message: String = "") -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot kick, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot kick, no permission.")
		return
	
	# Build and send request
	var message_bytes: PackedByteArray = message.substr(0, 255).to_utf8_buffer()
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(4)
	packet.encode_u8(0, _Serverbound.KICK_PEER)
	packet.encode_u16(1, _from_local_id(peer_id))
	packet.encode_u8(3, message_bytes.size())
	if (message_bytes.size() > 0): packet.append_array(message_bytes)
	_ws.send(packet)

## Ban another player from the lobby.
## (host/moderator only)
func ban(peer_id: int, message: String = "") -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot ban, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot ban, no permission.")
		return
	
	# Build and send request
	var message_bytes: PackedByteArray = message.substr(0, 255).to_utf8_buffer()
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(4)
	packet.encode_u8(0, _Serverbound.BAN_PEER)
	packet.encode_u16(1, _from_local_id(peer_id))
	packet.encode_u8(3, message_bytes.size())
	if (message_bytes.size() > 0): packet.append_array(message_bytes)
	_ws.send(packet)

# Setters / Getters

## Returns the UUID of the lobby.
func get_lobby_id() -> String:
	return _lobby_id

## Returns the join code of the lobby.
func get_join_code() -> String:
	return _join_code

## Returns the name of the lobby.
func get_lobby_name() -> String:
	return _lobby_name

## Returns the game mode of the lobby.
func get_game_mode() -> int:
	return _game_mode

## Returns the player limit of the lobby.
func get_player_limit() -> int:
	return _player_limit

## Returns the visibility mode of the lobby.
func get_visibility_mode() -> Visibility:
	return _visibility

## Returns the peer ID of the current host.
func get_host_id() -> int:
	return _to_local_id(_host_id)

## Returns a list of connected peer IDs.
func get_peers() -> Array[int]:
	return _peers.keys()

## Returns locally cached user data for a given peer ID.
## Prefer to use this over relaying information from the host.
func get_user(peer_id: int) -> EzchaUser:
	return _peers.get(peer_id, null)

## Returns what the current pending operation is.
func get_operation() -> Operation:
	return _operation

## Change the name of the lobby.
## (host/moderator only, requires migration to be enabled)
func set_lobby_name(new_name: String) -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot update name, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot update name, no permission.")
		return
	
	# Build and send request
	var name_buf: PackedByteArray = new_name.substr(0, 32).to_utf8_buffer()
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(3)
	packet.encode_u8(0, _Serverbound.UPDATE_LOBBY)
	packet.encode_u8(1, _OptionFlag.NAME)
	packet.encode_u8(2, name_buf.size())
	packet.append_array(name_buf)
	_ws.send(packet)

## Change the game mode of the lobby.
## (host/moderator only, requires migration to be enabled)
func set_game_mode(new_mode: int) -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot update game mode, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot update game mode, no permission.")
		return
	
	# Build and send request
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(3)
	packet.encode_u8(0, _Serverbound.UPDATE_LOBBY)
	packet.encode_u8(1, _OptionFlag.GAME_MODE)
	packet.encode_u8(2, new_mode)
	_ws.send(packet)

## Change the player limit of the lobby.
## (host/moderator only, requires migration to be enabled)
func set_player_limit(new_limit: int) -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot update player limit, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot update player limit, no permission.")
		return
	
	# Build and send request
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(3)
	packet.encode_u8(0, _Serverbound.UPDATE_LOBBY)
	packet.encode_u8(1, _OptionFlag.MAX_PLAYERS)
	packet.encode_u8(2, new_limit)
	_ws.send(packet)

## Change the visibility of the lobby.
## (host/moderator only, requires migration to be enabled)
func set_visibility(new_visibility: Visibility) -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot update visibility, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot update visibility, no permission.")
		return
	
	# Build and send request
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(3)
	packet.encode_u8(0, _Serverbound.UPDATE_LOBBY)
	packet.encode_u8(1, _OptionFlag.VISIBILITY)
	packet.encode_u8(2, new_visibility)
	_ws.send(packet)

## Manually migrate host to another peer.
## (host/moderator only, requires migration to be enabled)
func migrate_host(peer_id: int) -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot migrate hosts, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot migrate hosts, no permission.")
		return
	
	# Build and send request
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(4)
	packet.encode_u8(0, _Serverbound.UPDATE_LOBBY)
	packet.encode_u8(1, _OptionFlag.HOST_PEER_ID)
	packet.encode_u16(2, _from_local_id(peer_id))
	_ws.send(packet)

## Close the lobby and kick all players.
## (host/moderator only)
func close_lobby(message: String = "") -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot close lobby, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot close lobby, no permission.")
		return
	
	# Build and send request
	var message_bytes: PackedByteArray = message.substr(0, 255).to_utf8_buffer()
	var message_len: int = message_bytes.size()
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(2)
	packet.encode_u8(0, _Serverbound.CLOSE_LOBBY)
	packet.encode_u8(1, message_len)
	if (message_len > 0): packet.append_array(message_bytes)
	_ws.send(packet)

# Interface

## Returns true if currently connected to a lobby
func in_lobby() -> bool:
	return (_mock_status == ConnectionStatus.CONNECTION_CONNECTED)

## Returns if the current peer is the host.
func is_host() -> bool:
	return (_unique_id == _host_id)

## Returns if the current peer can modify the lobby.
func can_modify_lobby() -> bool:
	return (is_host() || (_ezcha.client.is_authenticated() && _ezcha.client.moderation_tools))

# Miscellaneous helpers

func _to_local_id_unmasked(server_id: int) -> int:
	return server_id + _GODOT_ID_OFFSET

func _to_local_id(server_id: int) -> int:
	if (server_id == _host_id): return 1
	return server_id + _GODOT_ID_OFFSET

func _from_local_id(local_id: int) -> int:
	if (local_id == 1): return _host_id
	return local_id - _GODOT_ID_OFFSET

func _uuid_string_to_bytes(uuid_str: String) -> PackedByteArray:
	var cleaned: String = uuid_str.replace("-", "")
	var bytes: PackedByteArray = PackedByteArray()
	for i: int in 16: bytes.append(cleaned.substr(i * 2, 2).hex_to_int())
	return bytes

func _uuid_bytes_to_string(bytes: PackedByteArray) -> String:
	var hex_str: String = bytes.hex_encode()
	return "%s-%s-%s-%s-%s" % [
		hex_str.substr(0, 8),
		hex_str.substr(8, 4),
		hex_str.substr(12, 4),
		hex_str.substr(16, 4),
		hex_str.substr(20, 12)
	]

func _append_string(packet: PackedByteArray, value: String) -> void:
	var bytes: PackedByteArray = value.to_utf8_buffer()
	var offset = packet.size()
	packet.resize(offset + 1)
	packet.encode_u8(offset, bytes.size())
	packet.append_array(bytes)

# Networking helpers

# Used BEFORE connection to relay server has opened.
func _handle_connection_failed() -> void:
	_operation = Operation.NONE
	_operation_result = null
	_mock_status = CONNECTION_DISCONNECTED
	_ws = null

# Used AFTER connection to relay server has opened.
func _handle_disconnect() -> void:
	_incoming_packets.clear()
	if (_ws != null):
		var ws_state: WebSocketPeer.State = _ws.get_ready_state()
		if (ws_state == _ws.State.STATE_CONNECTING || ws_state == _ws.State.STATE_OPEN):
			_ws.close()
		_ws = null
	if (!_peers.is_empty()):
		for peer_id: int in _peers.keys():
			peer_disconnected.emit(peer_id)
			user_disconnected.emit(peer_id, _peers[peer_id])
		_peers.clear()
	if (_guest_session):
		_ezcha.client._reset_state()
		_guest_session = false
	_unique_id = -1
	_host_id = -1
	_lobby_id = ""
	_game_mode = -1
	_player_limit = -1
	_refuse_connections = false
	_initializing = false
	_authenticated = false
	_mock_status = CONNECTION_DISCONNECTED
	_operation = Operation.NONE
	_operation_result = null

func _prepare_connection() -> bool:
	if (_operation != Operation.NONE || _ws != null):
		error.emit(ErrorType.CLIENT_EXCEPTION, "Already connecting/connected.")
		return false
	_operation = Operation.CONNECT
	_operation_result = null
	_mock_status = CONNECTION_CONNECTING
	return true

func _open_connection(address: String) -> bool:
	# Connect to server
	_ws = WebSocketPeer.new()
	_ws.supported_protocols = ["ezcha-relay"]
	var err = _ws.connect_to_url("wss://%s/ws" % [address])
	if (err != OK):
		_handle_connection_failed()
		error.emit(ErrorType.CLIENT_EXCEPTION, "Server connection failed. (0)")
		return false
	
	# Wait for connection
	var tree: SceneTree = _ezcha.get_tree()
	while (is_instance_valid(tree) && _ws != null && _ws.get_ready_state() == WebSocketPeer.STATE_CONNECTING):
		await tree.process_frame
	
	# Check state/connection
	if (_ws == null || _ws.get_ready_state() != WebSocketPeer.STATE_OPEN):
		_handle_disconnect()
		error.emit(ErrorType.CLIENT_EXCEPTION, "Server connection failed. (1)")
		return false
	
	# Send handshake
	if (!await _send_handshake()):
		_handle_disconnect()
		return false
	return true

func _send_handshake() -> bool:
	# Update state
	_initializing = true
	_authenticated = false
	_operation = Operation.HANDSHAKE
	_operation_result = null
	
	# Build/send packet
	var packet: PackedByteArray = PackedByteArray()
	packet.append(_Serverbound.HANDSHAKE)
	_append_string(packet, "Ezcha Relay")
	packet.append(0) # Protocol version
	_append_string(packet, _ezcha.client.get_session_token())
	_append_string(packet, EzchaUtil.get_game_version())
	_ws.send(packet)
	
	# Wait for response
	var tree: SceneTree = _ezcha.get_tree()
	while (is_instance_valid(tree) && _operation == Operation.HANDSHAKE):
		await tree.process_frame
	
	# Check response
	return (_operation_result != null && _operation_result)

func _send_join_request(lobby_id: String) -> bool:
	# Update state
	_operation = Operation.JOIN_LOBBY
	_operation_result = null
	
	# Build and send request
	var packet: PackedByteArray = PackedByteArray()
	packet.append(_Serverbound.JOIN_LOBBY)
	packet.append_array(_uuid_string_to_bytes(lobby_id))
	_ws.send(packet)
	
	# Wait for response
	var tree: SceneTree = _ezcha.get_tree()
	while (is_instance_valid(tree) && _operation == Operation.JOIN_LOBBY):
		await tree.process_frame
	
	# Check response
	if (_join_code.is_empty()):
		_handle_disconnect()
		return false
	return true

func _send_create_request(name: String, players: int, game_mode: int, visibility: Visibility, host_migration: bool) -> String:
	# Update state
	_operation = Operation.CREATE_LOBBY
	_operation_result = null
	
	# Build and send request
	var packet: PackedByteArray = PackedByteArray()
	packet.append(_Serverbound.CREATE_LOBBY)
	_append_string(packet, name.substr(0, 32))
	packet.append(game_mode)
	packet.append(players)
	packet.append(visibility)
	packet.append(1 if host_migration else 0)
	_ws.send(packet)
	
	# Wait for response
	var tree: SceneTree = _ezcha.get_tree()
	while (is_instance_valid(tree) && _operation == Operation.CREATE_LOBBY):
		await tree.process_frame
	
	# Check response
	if (_join_code.is_empty()):
		_handle_disconnect()
		return ""
	return _join_code

func _can_put_packet() -> bool:
	return (_ws != null && _mock_status == ConnectionStatus.CONNECTION_CONNECTED)

func _can_get_packet() -> bool:
	return (_mock_status == ConnectionStatus.CONNECTION_CONNECTED && !_incoming_packets.is_empty())

# Packet handling

func _process_packets() -> void:
	while (_ws != null && _ws.get_available_packet_count() > 0):
		var packet: PackedByteArray = _ws.get_packet()
		if (packet.is_empty()): continue
		var packet_type: int = packet[0]
		if (packet_type == _Clientbound.GAME_DATA):
			_handle_game_packet(packet.slice(1))
			continue
		_handle_system_packet(packet_type, packet.slice(1))

func _handle_system_packet(packet_id: int, data: PackedByteArray) -> void:
	match (packet_id):
		_Clientbound.HANDSHAKE:
			_handle_handshake(data)
		_Clientbound.ASSIGN_ID:
			_handle_assign_id(data)
		_Clientbound.LOBBY_OPTIONS:
			_handle_lobby_options(data)
		_Clientbound.ADD_PEER:
			_handle_add_peer(data)
		_Clientbound.REMOVE_PEER:
			_handle_remove_peer(data)
		_Clientbound.ERROR:
			_handle_error(data)

func _handle_handshake(data: PackedByteArray) -> void:
	_authenticated = true
	_operation_result = true
	_operation = Operation.NONE
	
	# Simulate authentication for guest sessions
	if (_ezcha.client.is_authenticated()): return
	if (data.size() < 2):
		printerr("EzchaRelay: Invalid handshake data.")
		return
	
	# Parse guest profile
	var json_len: int = data.decode_u16(0)
	if (data.size() < 2 + json_len): return
	var json_str: String = data.slice(2, 2 + json_len).get_string_from_utf8()
	var user_data: Variant = JSON.parse_string(json_str)
	if (user_data == null || !(user_data is Dictionary)):
		printerr("EzchaRelay: Failed to parse guest user data.")
		return
	
	var guest_user: EzchaUser = EzchaUser.new()
	EzchaUtil.unpack_data(guest_user, user_data)
	_ezcha.client._simulate_guest_session(guest_user)
	_guest_session = true

func _handle_assign_id(data: PackedByteArray) -> void:
	if (data.size() < 19):
		printerr("EzchaRelay: Invalid assign ID data.")
		return
	
	_unique_id = data.decode_u16(0)
	_lobby_id = _uuid_bytes_to_string(data.slice(2, 18))
	
	var join_code_len: int = data.decode_u8(18)
	_join_code = data.slice(19, join_code_len + 19).get_string_from_utf8()

func _handle_lobby_options(data: PackedByteArray) -> void:
	if (data.size() < 7):
		printerr("EzchaRelay: Invalid lobby settings data.")
		return
	
	var name_len: int = data.decode_u8(0)
	var offset: int = 1 + name_len
	if (data.size() < offset + 6): return
	
	var new_name: String = data.slice(1, offset).get_string_from_utf8()
	if (new_name != _lobby_name):
		_lobby_name = new_name
		if (!_initializing): name_changed.emit(_lobby_name)
	
	var new_mode: int = data.decode_u8(offset)
	if (new_mode != _game_mode):
		_game_mode = new_mode
		if (!_initializing): game_mode_changed.emit(_game_mode)
	
	var new_limit: int = data.decode_u8(offset + 1)
	if (new_limit != _player_limit):
		_player_limit = new_limit
		if (!_initializing): player_limit_changed.emit(_player_limit)
	
	var new_vis: int = data.decode_u8(offset + 2)
	if (new_vis is Visibility && new_vis != _visibility):
		_visibility = new_vis
		if (!_initializing): visibility_changed.emit(_visibility)
	
	_refuse_connections = (data.decode_u8(offset + 3) > 0)
	
	var new_host_id: int = data.decode_u16(offset + 4)
	if (new_host_id != _host_id):
		if (_initializing): _host_id = new_host_id
		else: _handle_host_migration(new_host_id)
	
	# Finalize initialization
	if (!_initializing): return
	_initializing = false
	_mock_status = CONNECTION_CONNECTED
	lobby_connected.emit()
	match (_operation):
		Operation.CREATE_LOBBY: lobby_created.emit()
		Operation.JOIN_LOBBY: lobby_joined.emit()
	_operation = Operation.NONE
	_operation_result = null

func _handle_host_migration(new_server_id: int) -> void:
	# Track peer IDs
	var old_server_id: int = _host_id
	var old_local_id: int = _to_local_id_unmasked(old_server_id)
	var new_local_id: int = _to_local_id_unmasked(new_server_id)
	_host_id = new_server_id
	
	# Remap local IDs
	var old_data: EzchaUser = _peers.get(1)
	var new_data: EzchaUser = _peers.get(new_local_id)
	if (old_data != null):
		_peers[old_local_id] = old_data
		_peers.erase(1)
	if (new_data != null):
		_peers[1] = new_data
		_peers.erase(new_local_id)
	
	# Update spawners
	if (new_server_id == _unique_id):
		var spawners: Array[Node] = _ezcha.get_tree().get_nodes_in_group(_SPAWNER_GROUP)
		for spawner: Node in spawners:
			if (spawner is not EzchaMultiplayerSpawner): continue
			spawner._update_tracked()
	
	host_migrated.emit(old_local_id, new_local_id)

func _handle_add_peer(data: PackedByteArray) -> void:
	if (data.size() < 4):
		printerr("EzchaRelay: Invalid peer connected data.")
		return
	
	# Parse peer ID
	var real_id: int = data.decode_u16(0)
	var local_id: int = _to_local_id(real_id)
	var offset: int = 2
	if (_peers.has(local_id)): return
	
	# Read JSON string
	var json_len: int = data.decode_u16(offset)
	offset += 2
	if (offset + json_len > data.size()): return
	var json_str: String = data.slice(offset, offset + json_len).get_string_from_utf8()
	
	# Parse JSON
	var user_data: Variant = JSON.parse_string(json_str)
	if (user_data == null || !(user_data is Dictionary)):
		printerr("EzchaRelay: Failed to parse user data JSON for peer ", local_id)
		return
	
	# Unpack and map user data
	var peer_user: EzchaUser = EzchaUser.new()
	EzchaUtil.unpack_data(peer_user, user_data)
	_peers[local_id] = peer_user
	
	# Godot expects clients not to emit peer_connected for themselves
	if (is_host() || real_id != _unique_id): peer_connected.emit(local_id)
	user_connected.emit(local_id, peer_user)

func _handle_remove_peer(data: PackedByteArray) -> void:
	if (data.size() < 2): return
	var real_id: int = data.decode_u16(0)
	var local_id: int = _to_local_id(real_id)
	var user: EzchaUser = _peers.get(local_id, null)
	_peers.erase(local_id)
	peer_disconnected.emit(local_id)
	user_disconnected.emit(local_id, user)

func _handle_error(data: PackedByteArray) -> void:
	if (data.size() < 3):
		printerr("EzchaRelay: Invalid error data.")
		return
	
	var error_code: int = data.decode_u16(0)
	var message: String = ""
	
	var message_len: int = data.decode_u8(2)
	if (message_len > 0 && message_len + 3 <= data.size()):
		message = data.slice(3, message_len + 3).get_string_from_utf8()
	
	error.emit(error_code, message)
	if (error_code == ErrorType.KICKED):
		kicked.emit(message)
		_handle_disconnect()
		return
	
	_operation_result = null
	_operation = Operation.NONE

func _handle_game_packet(data: PackedByteArray) -> void:
	# Extract engine packet wrapped in relay packet
	var full_size: int = data.size()
	if (full_size <= _INCOMING_HEADER_SIZE):
		printerr("EzchaRelay: Game packet is below minimum size. (received: %d bytes)" % [full_size])
		return
	
	# Parse from_peer
	var real_id: int = data.decode_u16(0)
	var local_id = _to_local_id(real_id)
	if (!_peers.has(local_id)):
		printerr("EzchaRelay: Game packet received from missing peer.")
		return
	
	# Parse payload size
	var payload_size: int = data.decode_u16(2)
	var provided_size: int = full_size - _INCOMING_HEADER_SIZE + _GODOT_HEADER_SIZE
	if (provided_size < payload_size):
		printerr("EzchaRelay: Incomplete game packet. (%d/%d bytes)" % [provided_size, payload_size])
		return
	
	# RPC metadata
	var transfer_mode: int = data.decode_u8(4)
	if (transfer_mode > _MAX_TRANSFER_MODE):
		printerr("EzchaRelay: Invalid transfer mode from incoming game packet.")
		return
	var transfer_channel: int = data.decode_u8(5)
	
	# Extract original packet
	var game_data: PackedByteArray = data.slice(_INCOMING_HEADER_SIZE)
	var packet: EzchaRelayPacket = EzchaRelayPacket.new(game_data, local_id, transfer_mode, transfer_channel)
	_incoming_packets.append(packet)

# Extension overrides

func _poll() -> void:
	if (_ws == null): return
	
	var state: WebSocketPeer.State = _ws.get_ready_state()
	if (state == WebSocketPeer.STATE_CLOSED):
		_handle_disconnect()
		return
	
	_ws.poll()
	_process_packets()

func _put_packet_script(payload: PackedByteArray) -> int:
	if (!_can_put_packet()): return ERR_UNCONFIGURED
	
	# Determine mode and ID (broadcast all by default)
	var mode: int = 1 # 0 = forward, 1 = broadcast
	var has_peer: bool = (_target_peer != 0)
	var real_id: int = 0
	
	if (_target_peer < 0):
		# Broadcast excluding peer
		real_id = _from_local_id(abs(_target_peer))
	else:
		# 1 = forward to host, other = forward to peer
		mode = 0
		real_id = _host_id if (_target_peer == 1) else _from_local_id(_target_peer)
	
	# Build and send packet
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(9 if has_peer else 7)
	packet[0] = _Serverbound.GAME_DATA
	packet.encode_u8(1, mode)
	packet.encode_u8(2, 1 if has_peer else 0)
	var offset: int = 3
	if (has_peer):
		packet.encode_u16(offset, real_id)
		offset += 2
	packet.encode_u16(offset, payload.size() + _GODOT_HEADER_SIZE)
	packet.encode_u8(offset + 2, int(_transfer_mode)) # RPC metadata
	packet.encode_u8(offset + 3, int(_transfer_channel))
	packet.append_array(payload) # Original engine packet
	return _ws.send(packet)

func _get_max_packet_size() -> int:
	return _MAX_PACKET_SIZE

func _get_packet_script() -> PackedByteArray:
	if (!_can_get_packet()):  return PackedByteArray()
	return _incoming_packets.pop_front().data

func _get_available_packet_count() -> int:
	if (!_can_get_packet()): return 0
	return _incoming_packets.size()

func _get_packet_peer() -> int:
	if (!_can_get_packet()): return 0
	return _incoming_packets[0].from

func _close() -> void:
	_handle_disconnect()

func _disconnect_peer(p_peer: int, p_force: bool) -> void:
	kick(p_peer, "")

func _get_unique_id() -> int:
	return _to_local_id(_unique_id)

func _notification(what: int) -> void:
	if (what != NOTIFICATION_PREDELETE): return
	if (self == null): return # erm
	_handle_disconnect()

func _set_refuse_new_connections(value: bool) -> void:
	# Check state
	if (!in_lobby()):
		printerr("EzchaRelay: Cannot update options, not in lobby.")
		return
	if (!can_modify_lobby()):
		printerr("EzchaRelay: Cannot update options, no permission.")
		return
	
	_refuse_connections = value
	
	# Build and send request
	var packet: PackedByteArray = PackedByteArray()
	packet.resize(3)
	packet.encode_u8(0, _Serverbound.UPDATE_LOBBY)
	packet.encode_u8(1, _OptionFlag.REFUSE_CONNECTIONS)
	packet.encode_u8(2, 1 if value else 0)
	_ws.send(packet)

func _is_refusing_new_connections() -> bool:
	return _refuse_connections

func _is_server_relay_supported() -> bool:
	return true

func _is_server() -> bool:
	return is_host()

func _get_connection_status() -> ConnectionStatus:
	return _mock_status

func _set_target_peer(p_peer: int) -> void:
	_target_peer = p_peer

func _get_packet_channel() -> int:
	if (_incoming_packets.is_empty()): return 0
	return _incoming_packets[0].channel

func _get_packet_mode() -> TransferMode:
	if (_incoming_packets.is_empty()): return TRANSFER_MODE_RELIABLE
	return _incoming_packets[0].transfer_mode
	
func _set_transfer_channel(p_channel: int) -> void:
	_transfer_channel = p_channel

func _get_transfer_channel() -> int:
	return _transfer_channel

func _set_transfer_mode(p_mode: TransferMode) -> void:
	_transfer_mode = p_mode

func _get_transfer_mode() -> TransferMode:
	return _transfer_mode
