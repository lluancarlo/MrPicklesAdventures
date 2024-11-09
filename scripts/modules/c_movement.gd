extends Node
class_name CMovement


enum StateMovement {WALK, RUN}

@export_category(&"Nodes")
@export var _character : CharacterBody3D
@export var _armature : Node3D
@export_category(&"Variables")
@export var _walk_speed = 2.0
@export var _run_speed = 4.0
@export var _jump_speed = 4.5
@export var _rotation_transition = 0.15

var _camera : Camera3D
var gravity = ProjectSettings.get_setting(&"physics/3d/default_gravity")
var movement_state := StateMovement.WALK


func _ready() -> void:
	_camera = owner.get_node("%MainCamera3D")
	assert(_camera != null, "There is no main camera setted!")


func _process(_delta: float) -> void:
	# move_and_slide here fix the jitter problem
	_character.move_and_slide()


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not _character.is_on_floor():
		_character.velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(&"jump") and _character.is_on_floor():
		_character.velocity.y = _jump_speed
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector(&"left", &"right", &"forward", &"back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, _camera.rotation.y).normalized()
	
	var speed = _get_speed()
	if direction:
		_character.velocity.x = direction.x * speed
		_character.velocity.z = direction.z * speed
	else:
		_character.velocity.x = move_toward(_character.velocity.x, 0, speed)
		_character.velocity.z = move_toward(_character.velocity.z, 0, speed)
	
	if input_dir != Vector2.ZERO:
		_armature.look_at(_character.position - direction)


func _get_speed() -> float:
	match movement_state:
		StateMovement.WALK:
			return _run_speed
		StateMovement.WALK:
			return _walk_speed
		_:
			return 0
