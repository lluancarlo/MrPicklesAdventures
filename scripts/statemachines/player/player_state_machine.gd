extends LimboHSM
class_name PlayerStateMachine

@export_category("Configuration")
@export var c_animation : CAnimation
@export var c_movement : CMovement
@export var cb_character : CharacterBody3D

@export_category("States")
@export var idle_state : LimboState
@export var move_state : LimboState

var bb_values := PlayerBlackboard.new()


func _ready() -> void:
	blackboard.bind_var_to_property(&"bb_values", self, &"bb_values", true)
	_set_blackboard_values()
	_set_state_transitions()
	
	initial_state = idle_state
	
	initialize(self)
	set_active(true)


func _set_blackboard_values() -> void:
	assert(c_animation, "PlayerStateMachine.c_animation cannot be null")
	bb_values.c_animation = c_animation
	assert(c_movement, "PlayerStateMachine.c_movement cannot be null")
	bb_values.c_movement = c_movement
	assert(cb_character, "PlayerStateMachine.cb_character cannot be null")
	bb_values.cb_character = cb_character


func _set_state_transitions() -> void:
	add_transition(idle_state, move_state, StateTransitions.TO_MOVE)
	add_transition(move_state, idle_state, StateTransitions.TO_IDLE)


func _on_active_state_changed(current: LimboState, _previous: LimboState) -> void:
	DebugManager.update_info("PlayerSM", current.name)
