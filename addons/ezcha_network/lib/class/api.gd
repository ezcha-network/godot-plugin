extends Object
class_name EzchaAPI
## A base class for handling calls to the Ezcha Network API.

var _ezcha: EzchaSingleton = null

func _init(ez: EzchaSingleton) -> void:
	_ezcha = ez
