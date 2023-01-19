extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_testbutton_button_up():
	self.text = "fing unpressed"
	pass # Replace with function body.


func _on_testbutton_button_down():
	self.text = "fing pressed"
	pass # Replace with function body.
