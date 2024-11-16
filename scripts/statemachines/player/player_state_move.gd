extends LimboState
class_name PlayerStateMove

var _blackboard : PlayerBlackboard
var last_movement_state : int

func _enter() -> void:
	_blackboard = blackboard.get_var(&"bb_values")
	_blackboard.c_animation.set_state(CAnimation.AnimState.MOVE)
	last_movement_state = _blackboard.c_movement.movement_state


func _update(delta: float) -> void:
	if _blackboard.c_movement.movement_state != last_movement_state:
		last_movement_state = _blackboard.c_movement.movement_state
		_blackboard.c_animation.set_move_mode(last_movement_state)
	
	if _blackboard.cb_character.velocity.x == 0 and _blackboard.cb_character.velocity.z == 0:
		dispatch(StateTransitions.TO_IDLE)
