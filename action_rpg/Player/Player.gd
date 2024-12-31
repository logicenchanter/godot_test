extends KinematicBody2D

const ACCELERATION = 500   #it is frame based
const FRICTION = 500
const MAX_SPEED = 80


enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

#Delta has the time... 1/60 of second... in case of lag, 1/30 ! pixel per frame, to sum amount per second
#func _physics_process(delta):
func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#Fixing the velocity in all direction by normalizing.
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#		velocity = input_vector * MAX_SPEED  # for constant velocity
#		velocity += input_vector * ACCELERATION   #+= for acceleration
#		velocity += input_vector * ACCELERATION * delta  #+= for acceleration in time not frame
#		velocity = velocity.clamped(MAX_SPEED * delta)
#		velocity = velocity.clamped(MAX_SPEED) 		#It is not accurate.
#		print(velocity)
	else:
		animationState.travel("Idle")
#		velocity = Vector2.ZERO
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)		#Friction
#	move_and_collide(velocity * delta)
	velocity = move_and_slide(velocity) #It handle data for us

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE















# More info on velocity:
#      https://docs.godotengine.org/uk/latest/tutorials/misc/jitter_stutter.html





