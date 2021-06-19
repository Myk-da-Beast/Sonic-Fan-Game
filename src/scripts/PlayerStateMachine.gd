extends "res://scripts/StateMachine.gd"

var rootBoneOrigin = Transform()

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
	
	#rootBoneOrigin = parent.skelly.get_bone_global_pose(4)
	#print("global: ", parent.skelly.get_bone_global_pose(4))
	#print("  pose: ", parent.skelly.get_bone_pose((4)))
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y > 0:
					return states.jump
				elif parent.velocity.y < 0:
					return states.fall
			elif abs(parent.velocity.x) > parent.deadZone:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y > 0.1:
					return states.jump
				elif parent.velocity.y < -0.1:
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
			stateMachine.travel("run")
			parent.animTree.set("parameters/run/blend_position", 0)
			# parent.stateLabel.text = "idle"
		states.run:
			stateMachine.travel("run")
			var blend = parent.velocity.x / parent.MAX_SPEED
			# parent.animTree.set("parameters/run/blend_position", blend)
			# parent.stateLabel.text = "run"
		states.jump:
			stateMachine.travel("sc_jump_ball_loop")
			# parent.stateLabel.text = "jump"
		#states.fall:
			#parent.stateLabel.text = "fall"
	pass

func _exit_state(oldState, newState):
	pass
