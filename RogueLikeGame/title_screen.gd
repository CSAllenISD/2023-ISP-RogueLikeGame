extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $Buttons.get_children():
		button.connect("pressed", self, "_onButton_pressed", [button.scene_to_load])
	
func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Continue_pressed():
	pass # Replace with function body.


func _on_OptionsButton_pressed():
	pass # Replace with function body.
