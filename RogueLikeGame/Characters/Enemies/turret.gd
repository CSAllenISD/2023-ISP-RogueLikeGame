extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var max_timer = .4
export var projectile_speed = 100
var timer = max_timer
var chara
var ARROW = load("res://RogueLikeGame/Projectiles/testProjectile.tscn")
var arrow
var max_health = 100
var health = 100
var proj_list = []
var main# Called when the node enters the scene tree for the first time.
onready var playerdetectionzone = $PlayerDetectionZone

onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	self.main = get_parent()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	  #position of player minus enemy position will give us direction
  

	#get angle from direction (Note roation is in radians)  
	
	if self.health <= 0:
		queue_free()
	timer -= delta 
	$Sprite.frame = 0
	if timer <= 0 and playerdetectionzone.can_see_player() == true:
		timer = max_timer
		arrow = ARROW.instance()
		arrow.position = self.position
		var player_pos = player.position
		
		arrow.look_at(player_pos)
		arrow.DIRECTION = get_angle_to(player_pos)
		arrow._velocity = Vector2(0,projectile_speed).rotated(get_angle_to(player_pos) - 1.5708)
		main.add_child(arrow)
		$Sprite.frame = 1
		$Fireball.play()
		#print(get_angle_to(player.global_position))
		


func _on_Hurtbox_area_entered(area):
	chara = area.get_parent().get_parent()
	if chara.name == "character":
		self.health -= 30
	pass # Replace with function body.






