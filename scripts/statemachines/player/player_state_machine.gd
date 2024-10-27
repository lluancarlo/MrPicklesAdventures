extends LimboHSM
class_name PlayerStateMachine

@export var c_animation : CAnimation

@export var first_state : LimboState


func _bind_blackboard_vars() -> void:
	blackboard.bind_var_to_property(PlayerBB.C_ANIMATION, self, &"c_animation", true)


func _ready() -> void:
	_bind_blackboard_vars()
	
	initial_state = first_state if first_state != null else get_child(0)
	
	initialize(self)
	set_active(true)
