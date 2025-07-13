extends Node
class_name AnimationController

signal animation_finished(anim_name: String)

@export_category(&"Nodes")
@export var _anim_tree : AnimationTree

var current_anim_state : AnimState
var current_walk_mode : WalkMode
var current_move_mode : GlobalEnums.MoveMode

const MAX_WALK_SCALE := 0.8 # This is sync with the animation
const MAX_RUN_SCALE := 0.9 # This is sync with the animation

enum AnimState { IDLE, MOVE }
enum WalkMode { NORMAL, INJURY, DRUNK }

	
func _ready() -> void:
	_anim_tree.animation_finished.connect(animation_finished.emit)
	set_move_mode(GlobalEnums.MoveMode.WALK_MAX)
	set_walk_mode(WalkMode.NORMAL)


func set_state(state: AnimState) -> void:
	if state == current_anim_state:
		return
	
	match(state):
		AnimState.IDLE:
			_anim_tree.set(&"parameters/conditions/" + &"on_idle", true)
			_anim_tree.set(&"parameters/conditions/" + &"on_move", false)
		AnimState.MOVE:
			_anim_tree.set(&"parameters/conditions/" + &"on_idle", false)
			_anim_tree.set(&"parameters/conditions/" + &"on_move", true)
	
	current_anim_state = state
	DebugManager.update_info("PlayerAnimationState", state)


func trigger_taunt(taunt: int) -> void:
	_anim_tree.set(&"parameters/idle/" + &"taunt/transition_request", taunt)
	_anim_tree.set(&"parameters/idle/" + &"random-taunt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func set_move_mode(mode: GlobalEnums.MoveMode) -> void:
	if mode == current_move_mode:
		return
	
	match(mode):
		GlobalEnums.MoveMode.WALK_MIN:
			_anim_tree.set(&"parameters/move/" + &"move-mode/transition_request", &"walk")
		GlobalEnums.MoveMode.WALK_MAX:
			_anim_tree.set(&"parameters/move/" + &"move-mode/transition_request", &"run")
		GlobalEnums.MoveMode.RUN:
			_anim_tree.set(&"parameters/move/" + &"move-mode/transition_request", "sprint")
	
	current_move_mode = mode
	DebugManager.update_info("PlayerAnimationMoveMode", mode)


func set_walk_scale(speed: float) -> void:
	if speed > MAX_WALK_SCALE:
		speed = MAX_WALK_SCALE
	
	if _anim_tree.get(&"parameters/move/" + &"walk-scale/scale") == speed:
		return
	
	_anim_tree.set(&"parameters/move/" + &"walk-scale/scale", speed)


func set_run_scale(speed: float) -> void:
	if speed > MAX_RUN_SCALE:
		speed = MAX_RUN_SCALE
	
	if _anim_tree.get(&"parameters/move/" + &"run-scale/scale") == speed:
		return
	
	_anim_tree.set(&"parameters/move/" + &"run-scale/scale", speed)


func set_walk_mode(mode: WalkMode) -> void:
	if mode == current_walk_mode:
		return
	
	match(mode):
		WalkMode.NORMAL:
			_anim_tree.set(&"parameters/move/" + &"walk-mode/transition_request", &"normal")
			_anim_tree.set(&"parameters/move/" + &"run-mode/transition_request", &"normal")
		WalkMode.INJURY:
			_anim_tree.set(&"parameters/move/" + &"walk-mode/transition_request", &"injury")
			_anim_tree.set(&"parameters/move/" + &"run-mode/transition_request", &"injury")
		WalkMode.DRUNK:
			_anim_tree.set(&"parameters/move/" + &"walk-mode/transition_request", &"drunk")
			_anim_tree.set(&"parameters/move/" + &"run-mode/transition_request", &"drunk")
	
	current_walk_mode = mode
	DebugManager.update_info("PlayerAnimationWalkMode", mode)
