extends "res://scripts/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	# call methods on parent like parent.apply_gravity
	parent._apply_velocity(delta)
	pass

func _get_transition(delta):

	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y > 0:
					return states.jump
				elif parent.velocity.y < 0:
					return states.fall
			elif abs(parent.velocity.x) > 0.01:
				print(state)
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y > 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y <= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.jump
				
	return null

func _enter_state(newState, oldState):
	var stateMachine = parent.animTree["parameters/playback"]
	match newState:
		states.idle:
			#parent.animationPlayer.play("sc_boost_loop")
			parent.stateLabel.text = "idle"
		states.run:
			#parent.animationPlayer.stop()
			#parent.animationPlayer.play("sc_run_loop")
			stateMachine.travel("sc_run_blend_loop")
			parent.stateLabel.text = "run"
		states.jump:
			#parent.animationPlayer.stop()
			#parent.animationPlayer.play("sc_jump_ball_loop")
			stateMachine.travel("sc_jump_ball_loop")
			parent.stateLabel.text = "jump"
		states.fall:
			#parent.animationPlayer.stop()
			#parent.animationPlayer.play("sc_jump_fall_loop")
			stateMachine.travel("sc_jump_fall_loop")
			parent.stateLabel.text = "fall"
	pass

func _exit_state(oldState, newState):
	pass
	
func _input(event):
	var xAxis = Input.get_joy_axis(0, JOY_AXIS_0)
	var yAxis = Input.get_joy_axis(0 ,JOY_AXIS_1)
	
	if (abs(xAxis) > parent.deadZone):
		parent.velocity.x += parent.xAxis * parent.ACCELERATION * parent.delta
		parent.velocity.x = clamp(parent.velocity.x, -parent.MAX_SPEED, parent.MAX_SPEED)
		parent.sprite.flip_h = xAxis < 0
		
	if [states.idle, states.run].has(state):
		if Input.is_action_just_pressed("ui_up"):
			parent.velocity.y = parent.JUMP_FORCE
		if abs(xAxis) <= parent.deadZone:
			parent.velocity.x = lerp(parent.velocity.x, 0, parent.FRICTION)
			
	if [states.jump, states.fall].has(state):
		if Input.is_action_just_released("ui_up") and parent.velocity.y < -parent.JUMP_FORCE/2:
			parent.velocity.y = parent.JUMP_FORCE/2
		if abs(xAxis) > parent.deadZone:
			parent.velocity.x = lerp(parent.velocity.x, 0, parent.AERIAL_H_RESISTANCE)
	#if parent.is_on_floor():
	#	if abs(xAxis) <= parent.deadZone:
	#		parent.velocity.x = lerp(parent.velocity.x, 0, parent.FRICTION)
	#		parent.animationPlayer.play("Idle")
		#if Input.is_action_just_pressed("ui_accept"):
		#	parent.velocity.y = -parent.JUMP_FORCE
	#else:
	#	parent.animationPlayer.stop()
	#	if Input.is_action_just_released("ui_accept") and parent.velocity.y < -parent.JUMP_FORCE/2:
	#		parent.velocity.y = -parent.JUMP_FORCE/2
	#	if abs(xAxis) > parent.deadZone:
	#		parent.velocity.x = lerp(parent.velocity.x, 0, parent.AERIAL_H_RESISTANCE)
