extends Node2D


const SPEED = 10
const LIFESPAN = 5 # amount of time until projectile dies
var _life
var _velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	self._life = LIFESPAN
	self._velocity = Vector2(0,-1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self._life -= delta 
	if self._life <= 0:
		destroy()
	
func destroy():
	print("blew up")
	queue_free()
	
	
func _on_Area2D_body_entered(body):
	if body.name == "character":
		body.health -= 30
		
	destroy()
	pass # Replace with function body.
