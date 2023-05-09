extends KinematicBody2D

var save_file = SaveFile.game_data

export var ACCELERATION = 600
export var MAX_SPEED = 150
export var FRICTION = 1500
export var max_health = 100
export var rock_speed = 500
export var projectile_cooldown = 0

var keys = 0


onready var timer = $InvulnerabilityTimer
signal health_updated(health)
signal killed()

onready var main = get_parent()
enum{
	MOVE,
	DASH,
	ATTACK,
	HURT,
}
onready var health = max_health

var dash_vector = Vector2.ZERO 
var dash_speed = 35
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

func _ready():
	pass


func _process(delta):
	health = SaveFile.health
	match state:
		MOVE: 
			move_state(delta)

		ATTACK:
			attack_state(delta)
			
		HURT:
			hurt_state(delta)
	mouse_direction = Vector2(get_global_mouse_position() - global_position).normalized()
	animationTree.set("parameters/Idle/blend_position", mouse_direction)
	animationTree.set("parameters/Run/blend_position", mouse_direction)
	animationTree.set("parameters/PipeAttack/blend_position", mouse_direction)
	if melee_cooldown > 0:
		melee_cooldown -= delta
	if dash_cooldown > 0:
		dash_cooldown -= delta
	if projectile_cooldown > 0:
		projectile_cooldown -= 1
		
		
		
		#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<OTHER ACTIONS>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	if Input.is_action_just_pressed("dash"):
		if dash_cooldown <= 0:
			dash()
			dash_cooldown += 1
	if Input.is_action_just_pressed("Shoot"):
		if projectile_cooldown <= 0:
			var rock_instance = rock.instance()
			rock_instance.position = get_global_position()
			rock_instance.rotation_degrees = rotation_degrees
			if rock_instance != null:
				rock_instance.apply_impulse(Vector2(),Vector2(mouse_direction) * rock_speed)
				get_tree().get_root().add_child(rock_instance)
				projectile_cooldown += 50
	
	
			
	if keys == 0:
		$UI/keysprite.visible = false
		$UI/keysprite2.visible = false
		$UI/keysprite3.visible = false
	elif keys == 1:
		$UI/keysprite.visible = true
	elif keys == 2:
		$UI/keysprite2.visible = true
	elif keys == 3:
		$UI/keysprite3.visible = true
	
		
			
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

		
var dash_timer = 1
func dash():
	velocity * 400
	ACCELERATION = 2000
	MAX_SPEED = 9999999
	$DashTimer.start()
	
func _on_DashTimer_timeout():
	velocity / 400
	MAX_SPEED = 150
	ACCELERATION = 600
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



func hurt_state(delta):
	$Hurtbox/CollisionShape2D2.disabled = true
	
	$Sprite.hide()
	$Hurt.show()
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	#makes movement speed at angles = to straight directions
	if input_vector != Vector2.ZERO:
		#print(input_vector)
		dash_vector = input_vector

		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	#$DashSprite.hide()
	velocity = move_and_slide(velocity)
func melee():
	
	
	if melee_cooldown <= 0:
		attack_timer = SaveFile.Attack_Speed
		state = ATTACK
		melee_cooldown += SaveFile.Attack_Speed
		attack = MELEE.instance()
		attack.rotate(get_angle_to(get_global_mouse_position()))
		attack.position = $attackPoint.position
		self.add_child(attack)
		
		$Slash.play()
func attack_state_finished():
	
	state = MOVE
	$Sprite.visible = true
	
#PROJECTILES
var rock = preload("res://RogueLikeGame/Projectiles/rock.tscn")




func _on_Hurtbox_area_entered(area):
	state = HURT
	SaveFile.health -= area.get_parent().DAMAGE
	print(SaveFile.health)
	
	$HurtSound.play()
	$InvulnerabilityTimer.start()

func _on_InvulnerabilityTimer_timeout():
	$Hurtbox/CollisionShape2D2.disabled = false
	state = MOVE
	$Hurt.hide()
