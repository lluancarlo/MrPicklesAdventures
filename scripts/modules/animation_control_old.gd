extends Node
class_name AnimationControlOld


@export_category(&"Nodes")
@export var _character : CharacterBody3D
@export var _anim_tree : AnimationTree
@export var _jump_raycast : RayCast3D
@export_category(&"Variables")
@export var _anim_transition = 0.15


func _physics_process(delta: float) -> void:
	process_walk()
	process_jump()


func process_walk() -> void:
	#if not is_on_floor():
		#_anim_tree.set(&"parameters/conditions/is_on_air", true)
	#elif _anim_tree.get(&"parameters/conditions/is_on_air") && is_on_floor():
		#_anim_tree.set(&"parameters/conditions/is_on_air", false)
		#_anim_tree.set(&"parameters/Jump/conditions/is_soft_landing", true)
	#else:
		#_anim_tree.set(&"parameters/Jump/conditions/is_soft_landing", false)
		#_anim_tree.set(&"parameters/Jump/conditions/is_hard_landing", false)
	#
	if _character.velocity.length() == 0:
		_set_locomotion(0)
	elif _character.velocity.length() <= 3:
		_set_locomotion(1)
	elif _character.velocity.length() > 3:
		_set_locomotion(2)


func process_jump() -> void:
	if _jump_raycast.is_colliding():
		var origin = _jump_raycast.global_transform.origin
		var collision_point = _jump_raycast.get_collision_point()
		var distance = origin.distance_to(collision_point)
		if distance > 0.2:
			_anim_tree.set(&"parameters/Locomotion/OnAir/blend_amount", distance)
		else:
			_anim_tree.set(&"parameters/Locomotion/OnAir/blend_amount", 0.0)


func _get_locomotion() -> float:
	return _anim_tree.get(&"parameters/Locomotion/Locomotion/blend_position")

func _set_locomotion(value: float) -> void:
	_anim_tree.set(&"parameters/Locomotion/Locomotion/blend_position", lerp(_get_locomotion(), value, _anim_transition))
