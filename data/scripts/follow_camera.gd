extends Camera3D

# Higher values cause the field of view to increase more at high speeds.
const FOV_SPEED_FACTOR = 60
# Higher values cause the field of view to adapt to speed changes faster.
const FOV_SMOOTH_FACTOR = 0.2
# Don't change FOV if moving below this speed. This prevents shadows from flickering when driving slowly.
const FOV_CHANGE_MIN_SPEED = 0.05

# Position on the last physics frame (used to measure speed).
@onready var previous_position := global_position

@export var min_distance := 2.0
@export var max_distance := 4.0
@export var angle_v_adjust := 0.0
@export var height := 1.5
@export var is_aiming : bool
@export var aim_offset := Vector3(0.4, 0.1, 2.0)

var initial_transform := transform
var base_fov := fov
# The field of view to smoothly interpolate to.
var desired_fov := fov

func _ready():
	update_camera()


func _physics_process(_delta):
	if Input.is_action_just_pressed(&"debug"):
		is_aiming = !is_aiming
	
	#if is_aiming:
		#var target: Vector3 = get_parent().global_transform.origin
		#var pos := global_transform.origin
		#print(pos.distance_to(target))
		#if (get_parent().global_position - global_position).length() > 1.5:
			#global_position = lerp(previous_position, get_parent().global_position, 5 * _delta)
		#else:
			#global_position = get_parent().global_position
		#global_rotation = get_parent().global_rotation
		##look_at_from_position(pos, target, Vector3.UP)
		#
	#else:
	var target := get_parent().global_transform.origin as Vector3
	var pos := global_transform.origin as Vector3
	var from_target := pos - target

	# Check ranges
	if from_target.length() < min_distance:
		from_target = from_target.normalized() * min_distance
	elif from_target.length() > max_distance:
		from_target = from_target.normalized() * max_distance

	from_target.y = height
	pos = target + from_target
	
	if is_aiming:
		#global_position.distance_to(target))
		global_position = lerp(global_position, target + aim_offset, 0.1)
		global_rotation = lerp(global_rotation, get_parent().global_rotation, 0.1)
	else:
		look_at_from_position(pos, target, Vector3.UP)

	previous_position = global_position


func update_camera():
	transform = initial_transform
	set_as_top_level(true)
