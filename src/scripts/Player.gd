extends KinematicBody

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AERIAL_H_RESISTANCE = 0.02
const GRAVITY = 98
const JUMP_FORCE = 120

var velocity = Vector3.ZERO
var deadZone = 0.1

onready var mesh = $Mesh
onready var animationPlayer = $Mesh/AnimationPlayer
onready var animTree = $AnimationTree
onready var stateLabel = $Label

func _apply_velocity(delta):
	velocity.y -= GRAVITY * delta
	
#	move_and_slide returns left over motion. Setting velocity equal
#   to this value will reset our y velocity whenever we hit the 
#   ground
	velocity = move_and_slide(velocity, Vector3.UP)
