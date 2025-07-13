extends LimboState
class_name PlayerStateMove


var _blackboard : PlayerBlackboard
var last_movement_state : GlobalEnums.MoveMode


func _enter() -> void:
	_blackboard = blackboard.get_var(&"bb_values")
	_blackboard.animation_controller.set_state(AnimationController.AnimState.MOVE)


func _update(_delta: float) -> void:
	if _blackboard.movement_controller.movement_state != last_movement_state:
		last_movement_state = _blackboard.movement_controller.movement_state
		_blackboard.animation_controller.set_move_mode(last_movement_state)
	
	if _blackboard.player_characterbody.velocity.x == 0 and _blackboard.player_characterbody.velocity.z == 0:
		dispatch(StateTransitions.TO_IDLE)
	elif _blackboard.player_characterbody.velocity.length() < _blackboard.movement_controller.get_desired_speed() - 0.1:
		_blackboard.animation_controller.set_walk_scale(_blackboard.player_characterbody.velocity.length() - 0.2)
