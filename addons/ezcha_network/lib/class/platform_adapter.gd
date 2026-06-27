extends RefCounted
class_name EzchaPlatformAdapter
## A class for internal use.
##
## Handles platform specific logic.

signal auth_flow_completed(token: String)
signal login_flow_completed(token: String)
signal logout_completed(success: bool)
signal session_expired()

var _ezcha: EzchaSingleton = null

# Lifecycle

func _init(singleton: EzchaSingleton) -> void:
	_ezcha = singleton

# Adapter

func supports_login() -> bool:
	return false

func _start_auth_flow() -> void:
	pass

func _start_login_flow() -> void:
	pass

func _logout() -> bool:
	return false

func _request_account_management() -> void:
	pass
