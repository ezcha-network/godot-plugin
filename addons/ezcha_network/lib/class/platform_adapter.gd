extends RefCounted
class_name EzchaPlatformAdapter
## A class for internal use to handle platform specific logic.
##
## You should never need to use this directly.

signal auth_flow_completed(token: Variant)
signal login_flow_completed(token: Variant)
signal logout_completed(success: bool)

var _ezcha: EzchaSingleton = null

func _init(singleton: EzchaSingleton) -> void:
	_ezcha = singleton

func supports_login() -> bool:
	return false

func _start_auth_flow() -> void:
	pass

func _start_login_flow() -> void:
	pass

func _logout() -> bool:
	return false
