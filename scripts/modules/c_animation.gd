extends Node
class_name CAnimation

signal animation_finished(anim_name: String)

@export_category(&"Nodes")
@export var _anim_tree : AnimationTree


enum AnimState {
	IDLE
}


func _ready() -> void:
	_anim_tree.animation_finished.connect(animation_finished.emit)


func set_state(state: AnimState) -> void:
	_anim_tree.set(&"parameters/conditions/on_idle", false)

	match(state):
		AnimState.IDLE:
			_anim_tree.set(&"parameters/conditions/on_idle", true)


func trigger_taunt(taunt: int) -> void:
	_anim_tree.set(&"parameters/Idle/Taunt/transition_request", taunt)
	_anim_tree.set(&"parameters/Idle/RandomTaunt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)