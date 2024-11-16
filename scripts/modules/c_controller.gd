extends Node
class_name CController


@export_category(&"Configuration")
# Print informations about input for every tick
@export var debug_info := true
# If enable, the game will only get inputs when the window is focused
@export var focus_mode := false

@export_category(&"Mouse")
@export var mouse_sensitivity := 0.05

@export_category(&"Joystick")
@export var default_axis_deadzone := 0.25

var inputs := ControllerInputs.new()
var is_focused := false


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			is_focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			is_focused = true


func _physics_process(delta: float) -> void:
	if focus_mode and not is_focused:
		return
	
	print_input(&"== Input Tick Values. Delta:", delta)
	
	if Input.get_connected_joypads().size() > 0:
		_process_joystic()
	else:
		_process_keyboard_and_mouse()


func _process_keyboard_and_mouse() -> void:
	process_axis_camera(Input.get_last_mouse_velocity() * mouse_sensitivity)
	process_axis_move(Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down"))
	process_action_jump(Input.is_action_pressed(&"action_jump"))
	process_action_run(Input.is_action_pressed(&"action_run"))
	process_action_walk(Input.is_action_pressed(&"action_walk"))


func _process_joystic() -> void:
	process_axis_camera(Input.get_vector(&"camera_left", &"camera_right", &"camera_up", &"camera_down", default_axis_deadzone))
	var axis = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down", default_axis_deadzone)
	process_axis_move(axis)
	process_action_jump(Input.is_action_pressed(&"action_jump"))
	process_action_run(Input.is_action_pressed(&"action_run"))
	process_action_walk(axis.length() < 0.7)


func print_input(input: String, value):
	if debug_info:
		print(&"%s: %s" % [input, value])


func process_axis_move(value: Vector2) -> void:
	if value.length() > default_axis_deadzone:
		inputs.axis_move = value
	else:
		inputs.axis_move = Vector2.ZERO
	print_input(&"axis_move", inputs.axis_move)


func process_axis_camera(value: Vector2) -> void:
	if value.length() > default_axis_deadzone:
		inputs.axis_camera = value
	else:
		inputs.axis_camera = Vector2.ZERO
	print_input(&"axis_camera", inputs.axis_camera)


func process_action_jump(isPressed: bool) -> void:
	inputs.action_jump = isPressed
	print_input(&"action_jump", inputs.action_jump)


func process_action_run(isPressed: bool) -> void:
	inputs.action_run = isPressed
	print_input(&"action_run", inputs.action_run)


func process_action_walk(isPressed: bool) -> void:
	inputs.action_walk = isPressed
	print_input(&"action_walk", inputs.action_walk)
