extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("move_left"):
		self.position[0] -= 1
		pass 
	
	if Input.is_action_pressed("move_right"):
		self.position[0] += 1
		pass 
	if Input.is_action_pressed("move_up"):
		self.position[1] -= 1
		pass 
	if Input.is_action_pressed("move_down"):
		self.position[1] += 1
		pass 
