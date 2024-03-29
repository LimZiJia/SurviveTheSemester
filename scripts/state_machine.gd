class_name StateMachine
## This class represents a finite state machine. It is heavily based off
## Firebelley's GodotUtilies library written in C# which can be found at 
## https://github.com/firebelley/GodotUtilities
##
## In this implementation, states, enter/leaving states are all represented
## by functions. The state machine should be updated via the update() method in
## either the _process or _physics_process method.

## Emitted when the state is changed. This signal is emitted after the
## leaving state invocation and before the entering state invocation.
signal state_changed

## Represents all the states as a dictionary, where the state of type Callable are the keys
## and the state flows of type StateFlows are the values.
var states := {} as Dictionary

## Represents the current state.
var current_state: Callable

## Represents the node that the state machine belongs to. This must be set to
## use the change_state_with_delay method.
var owner: Node


## Adds a particular state to the state machine, together with optional functions called when the state is
## entered or left.
func add_states(state: Callable, enter_state: Callable = Callable(), leave_state: Callable = Callable()) -> void:
	var state_flows = StateFlows.new()
	state_flows.initialise(state, enter_state, leave_state)
	states[state] = state_flows

## Updates the state machine to the defined state, running the leave state of
## the current state if necessary. This will happened deferred to ensure
## changes in state do not affect the current frame.
func change_state(state: Callable) -> void:
	if states.has(state):
		(func(): set_state(states[state])).call_deferred()


## Updates the state machine to the defined state after the defined delay.
## If strict is true, the state change will not occur if another state change
## happens during the delay time. Note that the state_machine.owner must be 
## set to use this method.
func change_state_with_delay(state: Callable, delay: float, strict: bool = true) -> void:
	if owner == null:
		return
	
	var tween = owner.create_tween()
	tween.tween_interval(delay)
	tween.tween_callback(change_state.bind(state))
	
	if strict:
		state_changed.connect(tween.kill)

## Updates the initial state of the state machine to the defined state.
func set_initial_state(initial_state: Callable) -> void:
	if states.has(initial_state):
		set_state(states[initial_state])


## Performs the current states defined actions by invoking the Callable.
func update() -> void:
	if states.has(current_state):
		current_state.call()
		

## This function serves as a private function and should not be called directly.
func set_state(to_state_flow: StateFlows) -> void:
	if states.has(current_state):
		var from_state_flows := states[current_state] as StateFlows
		if not from_state_flows.leave_state.is_null():
			from_state_flows.leave_state.call()
	
	state_changed.emit()
	
	current_state = to_state_flow.state
	if not to_state_flow.enter_state.is_null():
		to_state_flow.enter_state.call()


## Represents a state, together with the functions called when the state is 
## entered or left.
class StateFlows:
	var state: Callable
	var enter_state: Callable
	var leave_state: Callable
	
	func initialise(state: Callable, enter_state: Callable, leave_state: Callable) -> void:
		self.state = state
		self.enter_state = enter_state
		self.leave_state = leave_state
