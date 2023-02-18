extends Node2D


const LIFESPAN = 2 # amount of time until projectile dies
const SPEED = 100
const DAMAGE = 10
var DIRECTION = 0#angle
var _velocity
var chara
var main
var EFFECT = load("res://RogueLikeGame/Effects/test_projectile_destroy.tscn")
var anim_timer = .2
# Called when the node enters the scene tree for the first time.

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	#DIRECTION = rng.randf_range(0, 360.0)
	self.main = get_parent()
	#self.rotation_degrees = DIRECTION
	#self._velocity = Vector2(0,SPEED).rotated(DIRECTION*3.14/180)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
var time_alive = 0
func _process(delta):
	time_alive += delta
	if LIFESPAN - time_alive < 0:
		destroy()
	anim_timer -= delta	
	if anim_timer <= 0:
		anim_timer = .2
		if $Sprite.flip_h:
			$Sprite.flip_h = 0
		else:
			$Sprite.flip_h = 1
	self.position[0] += _velocity[0]*delta
	self.position[1] += _velocity[1]*delta
func destroy():
	var effect = self.EFFECT.instance()
	effect.position = self.position
	effect.rotation = self.rotation
	main.add_child(effect)
	queue_free()
	
	
func _on_Area2D_body_entered(body):
	chara = body.get_parent()
	if chara.name == "character":
		chara.health -= DAMAGE
	
	destroy()
	pass # Replace with function body.


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	_on_Area2D_body_entered(area)
	pass # Replace with function body.
