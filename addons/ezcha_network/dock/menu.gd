extends ScrollContainer

@onready var dock = get_node("../../../")
@onready var plugin: EzchaPlugin = dock.plugin

var ezcha: EzchaSingleton = null

func _opened() -> void:
	ezcha = EzchaSingleton._get_instance()
