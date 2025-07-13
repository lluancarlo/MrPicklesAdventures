extends LimboState
class_name PlayerStateIdle

@export var _tm_taunt : Timer
var _random : RandomNumberGenerator
var _blackboard : PlayerBlackboard


func _ready() -> void:
	_random = RandomNumberGenerator.new()


func _enter() -> void:
	_blackboard = blackboard.get_var(&"bb_values")
	_blackboard.animation_controller.set_state(AnimationController.AnimState.IDLE)

	_tm_taunt.start()


func _update(_delta: float) -> void:
	if _blackboard.player_characterbody.velocity.x != 0 or _blackboard.player_characterbody.velocity.z != 0:
		dispatch(StateTransitions.TO_MOVE)


func _exit() -> void:
	_tm_taunt.stop()


func _on_timer_taunt_timeout() -> void:
	var randomTaunt = _random.randi_range(1,3)
	_blackboard.animation_controller.trigger_taunt(randomTaunt)
