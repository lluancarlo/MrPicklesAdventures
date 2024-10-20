extends Node
class_name CombatControl


@export_category(&"Nodes")
@export var _character : CharacterBody3D
@export var _anim_tree : AnimationTree
@export var _jump_raycast : RayCast3D
@export_category(&"Variables")
@export var _anim_transition = 0.15

var on_combat : bool


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"punch") && not on_combat:
		on_combat = true
		toggle_combat()
		_anim_tree.set(&"parameters/Locomotion/blend_loc_combat/blend_amount", 1.0 if on_combat else 0.0)
		_anim_tree.set(&"parameters/Locomotion/shot_punch/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		#var on_punch = _anim_tree.get(&"parameters/conditions/punch")
		#if !on_punch:
			#_anim_tree.set(&"parameters/conditions/punch", !on_punch)
			#_anim_tree.set(&"parameters/conditions/no_punch", on_punch)
		
		#var tween = create_tween()
		#tween.tween_method(test, 0.0, 1.0, 0.5)
		#_anim_tree.set(&"parameters/Combat/shot_punch/request", &"Fire")
#
#
#func test(x):
	#_anim_tree.set(&"parameters/Combat/blend_punch_idle/blend_amount", x)


func toggle_combat() -> void:
	var on_combat = _anim_tree.get(&"parameters/conditions/on_combat")
	_anim_tree.set(&"parameters/conditions/on_combat", !on_combat)
	_anim_tree.set(&"parameters/conditions/off_combat", on_combat)
