extends LimboState
class_name PlayerStateMove

var _blackboard : PlayerBlackboard


func _enter() -> void:
	print("Player State: MOVE")

	_blackboard = blackboard.get_var(&"bb_values")
	_blackboard.c_animation.set_state(CAnimation.AnimState.MOVE)


func _update(delta: float) -> void:
	if _blackboard.cb_character.velocity.x == 0 and _blackboard.cb_character.velocity.z == 0:
		dispatch(StateTransitions.TO_IDLE)
