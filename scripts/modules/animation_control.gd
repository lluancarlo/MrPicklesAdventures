extends Node
class_name AnimationControl


@export_category(&"Nodes")
@export var _character : CharacterBody3D
@export var _anim_tree : AnimationTree
@export var _jump_raycast : RayCast3D
@export_category(&"Variables")
@export var _anim_transition = 0.15
var is_aiming : bool


#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed(&"debug"):
		#is_aiming = !is_aiming
	#process_walk()
#
#
#func process_walk() -> void:
	#var input_dir = Input.get_vector(&"left", &"right", &"forward", &"back")
	#input_dir.y *= -1
	#if _character.velocity.length() == 0:
		#_set_locomotion(input_dir)
	#elif _character.velocity.length() == 2:
		#_set_locomotion(input_dir/2)
	#elif _character.velocity.length() == 4:
		#_set_locomotion(input_dir)
#
#func _get_locomotion() -> Vector2:
	#return _anim_tree.get(&"parameters/Locomotion/blend_position")
#
#func _set_locomotion(value: Vector2) -> void:
	#_anim_tree.set(&"parameters/Locomotion/blend_position", lerp(_get_locomotion(), value, _anim_transition))
