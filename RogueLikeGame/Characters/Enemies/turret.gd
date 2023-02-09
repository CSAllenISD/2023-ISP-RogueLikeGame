extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = .4
var chara
var ARROW = load("res://RogueLikeGame/Projectiles/testProjectile.tscn")
var arrow
var health = 100
var proj_list = []
var main# Called when the node enters the scene tree for the first time.


func _ready():
	self.main = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.health <= 0:
		queue_free()
	timer -= delta 
	if timer <= 0:
		timer = .4
		arrow = ARROW.instance()
		arrow.position = self.position
		main.add_child(arrow)


func _on_Hurtbox_area_entered(area):
	chara = area.get_parent().get_parent()
	if chara.name == "character":
		self.health -= 30
	pass # Replace with function body.
