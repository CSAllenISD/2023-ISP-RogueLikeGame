extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("fing button loaded")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if self.pressed:
		print(get_tree())
		
		get_tree().change_scene("res://RogueLikeGame/scenes/Room1.tscn") 


func _on_testbutton_pressed():
	get_tree().change_scene("res://RogueLikeGame/titleScreen.tscn") 
	pass # Replace with function body.
