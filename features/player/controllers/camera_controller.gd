extends Node
class_name CameraController


@export_category(&"Nodes")
@export var _player_cam : PhantomCamera3D
@export var _aim_cam : PhantomCamera3D

@export_category(&"Parameters")
@export var min_pitch: float = -50
@export var max_pitch: float = 30
@export var min_yaw: float = 0
@export var max_yaw: float = 360


func _physics_process(_delta: float) -> void:
	#TODO: check this code out, it might be a better way to handle this
	if Input.is_action_just_pressed("menu"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("debug"):
		_aim_cam.priority = 20 if _player_cam.is_active() else 0
		
	if is_instance_valid(_player_cam):
		_set_pcam_rotation(_player_cam)
	if is_instance_valid(_aim_cam):
		_set_pcam_rotation(_aim_cam)


func _set_pcam_rotation(pcam: PhantomCamera3D) -> void:
	var pcam_rotation_degrees := pcam.get_third_person_rotation_degrees() - \
		Vector3(get_axis_camera().y, get_axis_camera().x, 0)
	# Clamp the rotation in the X axis so it go over or under the target
	pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
	# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
	pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
	# Change the SpringArm3D node's rotation and rotate around its target
	pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)


func get_axis_camera() -> Vector2:
	return Vector2.ZERO
	#return _controller.inputs.axis_camera
