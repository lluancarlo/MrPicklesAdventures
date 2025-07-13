extends Node
class_name MovementController

@export_category(&"Nodes")
@export var _character : CharacterBody3D
@export var _armature : Node3D
@export var _input_controller : InputController

@export_category(&"Debug Nodes")
@export var _debug_direction : RayCast3D
@export var _debug_rotation : RayCast3D

@export_category(&"Speeds")
@export var _walk_min_speed = 1.5
@export var _walk_max_speed = 3.0
@export var _run_speed = 5.0
@export var _jump_speed = 6.0
@export var _mesh_rotation_speed = 5.0
@export var _direction_acceleration = 10.0

var _camera : Camera3D
var gravity = ProjectSettings.get_setting(&"physics/3d/default_gravity")
var movement_state := GlobalEnums.MoveMode.WALK_MAX


func _ready() -> void:
	_camera = owner.get_node("%MainCamera3D")
	assert(_camera != null, "There is no main camera setted!")


func _process(_delta: float) -> void:
	# move_and_slide here fix the jitter problem
	_character.move_and_slide()


func _physics_process(delta: float) -> void:
	if _character.is_on_floor() and get_inputs().axis_move.length() > 0:
		# Handle jump
		if get_inputs().action_jump:
			_character.velocity.y = _jump_speed
		# Handle run
		if get_inputs().action_walk:
			movement_state = GlobalEnums.MoveMode.WALK_MIN
		elif get_inputs().action_run:
			movement_state = GlobalEnums.MoveMode.RUN
		else:
			movement_state = GlobalEnums.MoveMode.WALK_MAX
	
	else:
		# Add the gravity.
		_character.velocity.y -= gravity * delta * 1.5
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Vector3(get_inputs().axis_move.x, 0, get_inputs().axis_move.y)\
		.rotated(Vector3.UP, _camera.rotation.y)

	if direction:
		_character.velocity.x = move_toward(_character.velocity.x, direction.x * get_desired_speed(), delta * _direction_acceleration)
		_character.velocity.z = move_toward(_character.velocity.z, direction.z * get_desired_speed(), delta * _direction_acceleration)
	else:
		_character.velocity.x = move_toward(_character.velocity.x, 0, delta * _direction_acceleration)
		_character.velocity.z = move_toward(_character.velocity.z, 0, delta * _direction_acceleration)
	
	if get_inputs().axis_move != Vector2.ZERO:
		_armature.rotation.y = lerp_angle(_armature.rotation.y, atan2(-_character.velocity.x, -_character.velocity.z), _mesh_rotation_speed * delta)
	
	if is_instance_valid(_debug_direction):
		_debug_direction.target_position = direction
		_debug_direction.debug_shape_custom_color = _get_raytraycing_direction_color()
	if is_instance_valid(_debug_rotation):
		_debug_rotation.rotation.y = _armature.rotation.y


func get_inputs() -> ControllerInputs:
	return _input_controller.inputs


func get_desired_speed() -> float:
	match movement_state:
		GlobalEnums.MoveMode.WALK_MIN:
			return _walk_min_speed
		GlobalEnums.MoveMode.WALK_MAX:
			return _walk_max_speed
		GlobalEnums.MoveMode.RUN:
			return _run_speed
		_:
			return 0


func _get_raytraycing_direction_color() -> Color:
	match movement_state:
		GlobalEnums.MoveMode.WALK_MIN:
			return Color.ORANGE
		GlobalEnums.MoveMode.WALK_MAX:
			return Color.ORANGE_RED
		GlobalEnums.MoveMode.RUN:
			return Color.RED
		_:
			return 0
