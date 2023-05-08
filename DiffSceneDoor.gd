extends Node2D
var destinations = ["res://RogueLikeGame/Rooms/Room5.tscn", "res://RogueLikeGame/Rooms/Room6.tscn"]
var Destination 

func _on_Area2D_body_entered(body):
	choose_room()
	if Destination != null:
		get_tree().change_scene(Destination)
func choose_room():
	randomize()
	Destination = destinations[randi() % destinations.size()]
