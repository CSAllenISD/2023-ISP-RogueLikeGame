extends KinematicBody2D
const ACCELERATION = 600
const MAX_SPEED = 100
var FRICTION = 15000000

onready var main = get_parent()
enum{
	MOVE,
	DASH,
	ATTACK,
}
var max_health = 100
var health = 100

var state = MOVE
var velocity = Vector2.ZERO
var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
onready var sprite: Sprite = get_node("Sprite")
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var melee_cooldown = 0
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
	mouse_direction = Vector2(get_global_mouse_position() - global_position).normalized()
	animationTree.set("parameters/Idle/blend_position", mouse_direction)
	animationTree.set("parameters/Run/blend_position", mouse_direction)
	animationTree.set("parameters/PipeAttack/blend_position", mouse_direction)
	if melee_cooldown > 0:
		melee_cooldown -= delta
	
func move_state(delta):
	$Sprite.visible = true
	$PipeAttack.visible = false
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
		
		animationTree.set("parameters/Idle/blend_position", mouse_direction)
		animationTree.set("parameters/Run/blend_position", mouse_direction)
		animationTree.set("parameters/PipeAttack/blend_position", mouse_direction)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		melee()
	
	
var MELEE = load("res://RogueLikeGame/attacks/sword.tscn")
var attack


var attack_timer = .6
func attack_state(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		attack_state_finished() 
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	#makes movement speed at angles = to straight directions
	if input_vector != Vector2.ZERO:
		#print(input_vector)
		
		animationTree.set("parameters/Idle/blend_position", mouse_direction)
		animationTree.set("parameters/Run/blend_position", mouse_direction)
		animationTree.set("parameters/PipeAttack/blend_position", mouse_direction)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	$Sprite.visible = false
	$PipeAttack.visible = true
	animationState.travel("PipeAttack")
	#melee attack

func melee():
	
	
	if melee_cooldown <= 0:
		attack_timer = .6
		state = ATTACK
		melee_cooldown += 1
		attack = MELEE.instance()
		attack.rotate(get_angle_to(get_global_mouse_position()))
		attack.position = $attackPoint.position
		self.add_child(attack)
func attack_state_finished():
	
	state = MOVE
	$Sprite.visible = true
	$PipeAttack.visible = false
