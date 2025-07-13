extends Control
class_name DebugOverlay


@export var debug_values_block : VBoxContainer

var blocks : Dictionary


func add_block(label: String, value: String) -> void:
	if blocks.has(label):
		blocks[label].text = value
	else:
		_create_debug_block(label, value)


func _create_debug_block(label: String, value: String) -> void:
	var label_node = Label.new()
	label_node.set("theme_override_font_sizes/font_size", 20)
	label_node.set("theme_override_constants/outline_size", 5)
	label_node.set("theme_override_colors/font_outline_color", Color.BLACK)
	var value_node = label_node.duplicate()

	var box_node = HBoxContainer.new()
	box_node.set("theme_override_constants/separation", 10)
	
	debug_values_block.add_child(box_node)
	box_node.add_child(label_node)
	label_node.text = label + ":"
	box_node.add_child(value_node)
	value_node.text = value

	blocks[label] = value_node


func _on_update_fps_timeout() -> void:
	add_block("FPS", str(Engine.get_frames_per_second()))
