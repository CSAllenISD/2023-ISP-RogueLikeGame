extends Node2D


const SPEED = 10
const LIFESPAN = 30 # amount of time until projectile dies
var _life
var _velocity
var chara
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
	chara = body.get_parent()
	if chara.name == "character":
		chara.health -= 30
	print(chara)	
	destroy()
	pass # Replace with function body.


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	_on_Area2D_body_entered(area)
	pass # Replace with function body.
