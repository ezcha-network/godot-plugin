class_name EzchaMultiplayerSpawner
extends MultiplayerSpawner
## Extended MultiplayerSpawner that supports Ezcha Relay host migration.
## Works with other built-in multiplayer peers.

func _enter_tree() -> void:
	add_to_group(EzchaRelayMultiplayerPeer._SPAWNER_GROUP)

func _update_tracked() -> void:
	var spawn_node: Node = get_node_or_null(spawn_path)
	if (spawn_node == null): return
	var mp: MultiplayerAPI = multiplayer
	if (mp == null): return
	var spawn_scenes: PackedStringArray = PackedStringArray()
	for idx: int in get_spawnable_scene_count():
		spawn_scenes.append(get_spawnable_scene(idx))
	for child in spawn_node.get_children():
		var scene: String = child.get_scene_file_path()
		if (scene.is_empty() || !spawn_scenes.has(scene)): continue
		mp.object_configuration_remove(child, self)
		spawn_node.remove_child(child)
		spawn_node.add_child(child)
		child.ready.emit()
