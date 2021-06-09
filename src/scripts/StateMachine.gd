extends Node
class_name StateMachine

# Current state
var state = null setget set_state
var previousState = null

# possible states in the state machine
var states = {}

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

# performs logic for given state
# inheritors should override
func _state_logic(delta):
	pass

# manages transitions between states
# inheritors should override
func _get_transition(delta):
	return null
	
# called when a state is transitioned to
# inheritors should override
func _enter_state(newState, oldState):
	pass

# called when a state is transitioned away from
# inheritors should override
func _exit_state(oldState, newState):
	pass
	
# sets new state, then calls the enter_state and exit_state functions
func set_state(newState):
	previousState = state
	state = newState
	
	if previousState != null:
		_exit_state(previousState, state)
	if newState != null:
		_enter_state(state, previousState)

# adds new states to the state machine	
func add_state(state_name):
	states[state_name] = states.size()