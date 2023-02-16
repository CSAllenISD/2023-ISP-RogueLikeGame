extends KinematicBody2D
const ACCELERATION = 600
const MAX_SPEED = 100
var FRICTION = 15000000

enum{
	MOVE,
	DASH,
	ATTACK,
}
var max_health = 100
var health = 100

var state = MOVE
var velocity = Vector2.ZERO

onready var sprite: Sprite = get_node("Sprite")
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _process(delta):
	#if Input.is_action_just_pressed("attack"):
		#self.health -= 10
	match state:
		MOVE:
			move_state(delta)
		DASH:
			pass
		ATTACK:
			attack_state(delta)
	
	
func move_state(delta):
	#var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	#if mouse_direction.x > 0 and sprite.flip_h:
		#sprite.flip_h = false
	#elif mouse_direction.x < 0 and not sprite.flip_h:
		#sprite.flip_h = true
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	#makes movement speed at angles = to straight directions
	if input_vector != Vector2.ZERO:
		#print(input_vector)
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/PipeAttack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	#makes movement speed at angles = to straight directions
	if input_vector != Vector2.ZERO:
		#print(input_vector)
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/PipeAttack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	$Sprite.visible = false
	$PipeAttack.visible = true
	animationState.travel("PipeAttack")
func attack_state_finished():
	
	state = MOVE
	$Sprite.visible = true
	$PipeAttack.visible = false
