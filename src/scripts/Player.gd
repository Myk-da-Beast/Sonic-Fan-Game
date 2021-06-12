extends KinematicBody

const ACCELERATION = 256
const MAX_SPEED = 32
const FRICTION = 0.8
const AERIAL_H_RESISTANCE = 0.5
const GRAVITY = 256
const JUMP_FORCE = 64

var velocity = Vector3.ZERO
var deadZone = 0.1

onready var mesh = $Mesh
onready var animationPlayer = $Mesh/AnimationPlayer
onready var skelly = $"Mesh/RootNode (gltf orientation matrix)/RootNode (model correction matrix)/chr_classicsonicfbx/Node/RootNode/Node2/Skeleton"
onready var animTree = $AnimationTree
onready var stateLabel = $Label

func _apply_velocity(delta):
	velocity.y -= GRAVITY * delta
	
#	move_and_slide returns left over motion. Setting velocity equal
#   to this value will reset our y velocity whenever we hit the 
#   ground
	velocity = move_and_slide(velocity, Vector3.UP)
