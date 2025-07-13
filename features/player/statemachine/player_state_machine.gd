extends LimboHSM
class_name PlayerStateMachine


@export_category("Configuration")
@export var animation_controller : AnimationController
@export var movement_controller : MovementController
@export var player_characterbody : CharacterBody3D


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
	assert(animation_controller, "PlayerStateMachine.animation_controller cannot be null")
	bb_values.animation_controller = animation_controller
	assert(movement_controller, "PlayerStateMachine.movement_controller cannot be null")
	bb_values.movement_controller = movement_controller
	assert(player_characterbody, "PlayerStateMachine.player_characterbody cannot be null")
	bb_values.player_characterbody = player_characterbody


func _set_state_transitions() -> void:
	add_transition(idle_state, move_state, StateTransitions.TO_MOVE)
	add_transition(move_state, idle_state, StateTransitions.TO_IDLE)


func _on_active_state_changed(current: LimboState, _previous: LimboState) -> void:
	DebugManager.update_info("PlayerSM", current.name)
