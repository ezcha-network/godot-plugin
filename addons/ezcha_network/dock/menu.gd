extends ScrollContainer

@onready var dock = get_node("../../../")
@onready var plugin: EzchaPlugin = dock.plugin
@onready var ezcha: EzchaSingleton = EzchaSingleton._get_instance()

func _opened() -> void: pass
