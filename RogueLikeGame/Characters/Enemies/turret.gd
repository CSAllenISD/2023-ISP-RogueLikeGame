extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = .4
var chara
var ARROW = load("res://RogueLikeGame/Projectiles/testProjectile.tscn")
var arrow
var max_health = 100
var health = 100
var proj_list = []
var main# Called when the node enters the scene tree for the first time.
var player 

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
	if timer <= 0:
		timer = 1
		arrow = ARROW.instance()
		arrow.position = self.position
		var player_pos = get_parent().get_node("YSort/character").position
		
		arrow.look_at(player_pos)
		arrow.DIRECTION = get_angle_to(player_pos)
		arrow._velocity = Vector2(0,arrow.SPEED).rotated(get_angle_to(player_pos) - 1.5708)
		main.add_child(arrow)
		#print(get_angle_to(player.global_position))
		print(player_pos)


func _on_Hurtbox_area_entered(area):
	chara = area.get_parent().get_parent()
	if chara.name == "character":
		self.health -= 30
	pass # Replace with function body.
