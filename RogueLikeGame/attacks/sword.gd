extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const DAMAGE = 25
const PROJ_LIFE = .1
var proj_life = PROJ_LIFE  # how long until damage effect disapears
const SWING_LIFE = .3 #how long swing anim takes
var swing_life = SWING_LIFE
const swing_angle = 180

const proj_dist = 25


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.proj_life -= delta
	self.swing_life -= delta
	
	if swing_life > 0:
		$sword.rotation_degrees += delta/self.SWING_LIFE*swing_angle
	if swing_life <= 0 and swing_life > -1000:
		$sword.queue_free()
		swing_life = -1001
	pass
	if proj_life > 0:
		$slash.position[0] += delta/self.PROJ_LIFE*proj_dist
	if proj_life <= 0 and proj_life > -1000:
		$slash.queue_free()
		proj_life = -1001
	pass

var creature
func _on_hitbox_body_entered(body):
	creature = body.get_parent()
	print(creature)
	creature.health -= DAMAGE


func _on_hitbox_area_entered(area):
	_on_hitbox_body_entered(area)
	pass # Replace with function body.
