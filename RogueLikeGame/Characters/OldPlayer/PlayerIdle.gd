extends PlayerState
onready var sprite = get_node("Sprite")
func _ready():
	sprite.visible = true
var dash_vector = Vector2.DOWN
var dash_speed = 400

func physics_update(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
		#makes movement speed at angles = to straight directions
	if input_vector != Vector2.ZERO:
	
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity = move_and_slide(velocity)
		
	if Input.is_action_just_pressed("attack"):
		melee()
	if Input.is_action_just_pressed("dash"):
		state = DASH
