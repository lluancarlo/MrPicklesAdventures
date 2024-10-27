extends LimboState
class_name PlayerStateIdle

@export var _tm_taunt : Timer
var _c_anim : CAnimation
var _random : RandomNumberGenerator


func _ready() -> void:
	_random = RandomNumberGenerator.new()


func _enter() -> void:
	print("Player State: IDLE")

	_c_anim = blackboard.get_var(PlayerBB.C_ANIMATION)
	_c_anim.set_state(CAnimation.AnimState.IDLE)

	_tm_taunt.start()


func _exit() -> void:
	_tm_taunt.stop()


func _on_timer_taunt_timeout() -> void:
	var randomTaunt = _random.randi_range(1,3)
	_c_anim.trigger_taunt(randomTaunt)
