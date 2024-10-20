extends Node
class_name MovementControlOld


@export_category(&"Nodes")
@export var _character : CharacterBody3D
@export var _armature : Node3D
@export var _camera : Camera3D
@export_category(&"Variables")
@export var _walk_speed = 2.0#1.5
@export var _run_speed = 4.0#3.5
@export var _jump_speed = 4.5
@export var _rotation_transition = 0.15

var gravity = ProjectSettings.get_setting(&"physics/3d/default_gravity")
var is_running : bool


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not _character.is_on_floor():
		_character.velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(&"jump") and _character.is_on_floor():
		_character.velocity.y = _jump_speed
	
	is_running = Input.is_action_pressed(&"running")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector(&"left", &"right", &"forward", &"back")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, _camera.rotation.y)
	
	if direction:
		_character.velocity.x = direction.x * _get_speed()
		_character.velocity.z = direction.z * _get_speed()
	else:
		_character.velocity.x = move_toward(_character.velocity.x, 0, _get_speed())
		_character.velocity.z = move_toward(_character.velocity.z, 0, _get_speed())
	
	var new_rotation = atan2(_character.velocity.x, _character.velocity.z)
	if new_rotation != 0:
		_armature.rotation.y = lerp_angle(_armature.rotation.y, new_rotation, _rotation_transition)

	_character.move_and_slide()


func _get_speed() -> float:
	return _run_speed if is_running else _walk_speed
