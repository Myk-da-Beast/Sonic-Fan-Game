extends KinematicBody

const ACCELERATION = 0.046875# * 10
const DECELERATION = 0.5# * 10
const MAX_SPEED = 6# * 10
const FRICTION = 0.046875# * 10
const SLOPE_FACTOR = 0.125# * 10
const SLOPE_FACTOR_ROLLING_UPHILL = 0.078125# * 10
const SLOPE_FACTOR_ROLLING_DOWNHILL = 0.3125# * 10
const FALL_RESISTANCE = 2.5# * 10

const AERIAL_ACCELERATION = 0.09375# * 10
const GRAVITY = 0.21875 * 10
const JUMP_FORCE = 6.5# * 10

var velocity = Vector3.ZERO
var deadZone = 0.001

onready var mesh = $Mesh
# onready var animationPlayer = $Mesh/AnimationPlayer
# onready var skelly = $"Mesh/RootNode (gltf orientation matrix)/RootNode (model correction matrix)/chr_classicsonicfbx/Node/RootNode/Node2/Skeleton"
onready var animTree = $AnimationTree
onready var stateLabel = $Label
onready var velocityLabel = $Label2
onready var stateMachine = $StateMachine

func _apply_velocity(delta):
	stateLabel.text = str(is_on_floor())#stateMachine.state

	handle_input()
	velocity.y -= GRAVITY * delta

	if (velocity.x > deadZone):
		mesh.rotation.y = 0
	elif (velocity.x < -deadZone):
		mesh.rotation_degrees = Vector3(0, 180, 0)
	
#	move_and_slide returns left over motion. Setting velocity equal
#   to this value will reset our y velocity whenever we hit the 
#   ground
	velocity = move_and_slide(velocity, Vector3.UP)
	velocityLabel.text = str(abs(velocity.y))

	var blend = abs(velocity.x) / MAX_SPEED
	# animTree.set("parameters/sc_run_blend/blend_position", blend)
	animTree.set("parameters/run/Blend/blend_position", blend)
	animTree.set("parameters/run/TimeScale/scale", 5.0 * blend)

func handle_input():
	var pressedRight = Input.is_action_pressed("ui_right")
	var pressedLeft = Input.is_action_pressed("ui_left")
	var isMovingRight = velocity.x > 0
	var isMovingLeft = velocity.x < 0

	if (pressedRight && isMovingRight):
		velocity.x += ACCELERATION 
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	elif (pressedRight):
		velocity.x += DECELERATION
		# if (velocity.x > 0):
		# 	velocity.x = 0

	if (pressedLeft && isMovingLeft):
		velocity.x -= ACCELERATION
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	elif (pressedLeft):
		velocity.x -= DECELERATION
		# if (velocity.x < 0):
		# 	velocity.x = 0
	
	if (!pressedRight && !pressedLeft && velocity.x != 0):
		if (velocity.x > FRICTION):
			velocity.x -= FRICTION
		elif (velocity.x < -FRICTION):
			velocity.x += FRICTION
		else:
			velocity.x = 0
		
	if [stateMachine.states.idle, stateMachine.states.run].has(stateMachine.state):
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
		# if abs(xAxis) <= parent.deadZone && isJoypadInput:
		# 	parent.velocity.x = lerp(parent.velocity.x, 0, parent.FRICTION)
