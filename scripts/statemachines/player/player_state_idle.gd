extends LimboState
class_name PlayerStateIdle

@export var _tm_taunt : Timer
var _random : RandomNumberGenerator
var _blackboard : PlayerBlackboard


func _ready() -> void:
	_random = RandomNumberGenerator.new()


func _enter() -> void:
	_blackboard = blackboard.get_var(&"bb_values")
	_blackboard.c_animation.set_state(CAnimation.AnimState.IDLE)

	_tm_taunt.start()


func _update(delta: float) -> void:
	if _blackboard.cb_character.velocity.x != 0 or _blackboard.cb_character.velocity.z != 0:
		dispatch(StateTransitions.TO_MOVE)


func _exit() -> void:
	_tm_taunt.stop()


func _on_timer_taunt_timeout() -> void:
	var randomTaunt = _random.randi_range(1,3)
	_blackboard.c_animation.trigger_taunt(randomTaunt)
