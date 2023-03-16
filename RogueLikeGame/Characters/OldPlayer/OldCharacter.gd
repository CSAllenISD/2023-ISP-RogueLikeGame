extends KinematicBody2D
export var ACCELERATION = 600
export var MAX_SPEED = 150
export var FRICTION = 150000000000000000
export var max_health = 100

onready var timer = $InvulnerabilityTimer
signal health_updated(health)
signal killed()




onready var main = get_parent()
enum{
	MOVE,
	DASH,
	ATTACK,
}

onready var health = max_health

var dash_vector = Vector2.ZERO
var dash_speed = 20
var invincibility_time = .01

var state = MOVE
var velocity = Vector2.ZERO
var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
onready var sprite: Sprite = get_node("Sprite")
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var invul_timer = $InvulnerabilityTimer

var melee_cooldown = 0
var dash_cooldown = 0
func _process(delta):
	
	match state:
		MOVE: 
			move_state(delta)
		DASH: #space to dash
			if dash_cooldown <= 0:
				dash_vector = velocity
				dash_state(delta)
			else:
				state = MOVE
		ATTACK:
			attack_state(delta)
	mouse_direction = Vector2(get_global_mouse_position() - global_position).normalized()
	animationTree.set("parameters/Idle/blend_position", mouse_direction)
	animationTree.set("parameters/Run/blend_position", mouse_direction)
	animationTree.set("parameters/PipeAttack/blend_position", mouse_direction)
	if melee_cooldown > 0:
		melee_cooldown -= delta
	if dash_cooldown > 0:
		dash_cooldown -= delta

	
func move_state(delta):
	$Hurtbox/CollisionShape2D2.disabled = false
	$Sprite.visible = true


	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	#makes movement speed at angles = to straight directions
	if input_vector != Vector2.ZERO:
		#print(input_vector)
		dash_vector = input_vector
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
	if Input.is_action_just_pressed("dash"):
		state = DASH
		
var dash_timer = .02
func dash_state(delta):
	dash_cooldown = 2
	$Hurtbox/CollisionShape2D2.disabled = true
	animationTree.set("parameters/Dash/blend_position", mouse_direction)
	#$DashSprite.visible = true
	#$Sprite.visible = false
	dash_timer -= delta
	if dash_timer <= 0:
		dash_state_finished()
	timer.connect("timeout",self,"dash_state_finished")
	#timer.wait_time = 3
	#timer.one_shot = true
	#add_child(timer)
	#timer.start()
	move_and_slide(dash_vector * dash_speed) 
	

	
func dash_state_finished():
	#$DashSprite.visible = false
	#$Sprite.visible = true
	$Hurtbox/CollisionShape2D2.disabled = false
	dash_timer = .02
	state = MOVE
var MELEE = load("res://RogueLikeGame/attacks/sword.tscn")
var attack




func move():
	velocity = move_and_slide(velocity)

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
	#$Sprite.visible = false
	#$PipeAttack.visible = true
	animationState.travel("PipeAttack")
	#melee attack

func melee():
	
	
	if melee_cooldown <= 0:
		attack_timer = .3
		state = ATTACK
		melee_cooldown += .3
		attack = MELEE.instance()
		attack.rotate(get_angle_to(get_global_mouse_position()))
		attack.position = $attackPoint.position
		self.add_child(attack)
		
		$Slash.play()
func attack_state_finished():
	
	state = MOVE
	$Sprite.visible = true
	





func _on_InvulnerabilityTimer_timeout():
	dash_state_finished()
