extends Node


var _debug_overlay : DebugOverlay


func _ready() -> void:
	var d = get_node("../Game").get_node("DebugOverlay")
	_debug_overlay = d


func update_info(label: String, value: Variant) -> void:
	_debug_overlay.add_block(label, str(value))
