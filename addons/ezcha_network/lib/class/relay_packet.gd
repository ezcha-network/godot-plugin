extends RefCounted
class_name EzchaRelayPacket
## The class representing a relay packet received via Ezcha Relay.
##
## Stores Godot-specific metadata (transfer mode, channel) extracted from payload.
## Internal use only.

var data: PackedByteArray = PackedByteArray()
var from: int = -1
var transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE
var channel: int = 0

func _init(s_data: PackedByteArray, s_from: int, s_transfer_mode: int, s_channel: int) -> void:
	data = s_data
	from = s_from
	channel = s_channel
	match s_transfer_mode:
		0: transfer_mode = MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE
		1: transfer_mode = MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE_ORDERED
		2: transfer_mode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE
		_: transfer_mode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE
