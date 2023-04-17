extends Node2D



func _on_Area2D_body_entered(body):
	body.global_position = $Exit.global_position
