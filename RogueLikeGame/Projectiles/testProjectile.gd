extends Node2D


const LIFESPAN = 30 # amount of time until projectile dies
const SPEED = 100
const DAMAGE = 10
var DIRECTION = 0#angle
var _life
var _velocity
var chara
# Called when the node enters the scene tree for the first time.

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	DIRECTION = rng.randf_range(0, 360.0)
	self._life = LIFESPAN
	self.rotation_degrees = DIRECTION
	self._velocity = Vector2(0,SPEED).rotated(DIRECTION*3.14/180)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self._life -= delta 
	if self._life <= 0:
		destroy()
	self.position[0] += _velocity[0]*delta
	self.position[1	] += _velocity[1]*delta
	
func destroy():
	queue_free()
	
	
func _on_Area2D_body_entered(body):
	chara = body.get_parent()
	if chara.name == "character":
		chara.health -= DAMAGE
	print(chara)	
	destroy()
	pass # Replace with function body.


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	_on_Area2D_body_entered(area)
	pass # Replace with function body.
