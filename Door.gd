extends Node2D
export var Destination = "res://RogueLikeGame/Rooms/Room1.tscn"


func _on_Area2D_body_entered(body):
	
	get_tree().change_scene(Destination)
