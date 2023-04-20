extends Button

export(String) var scene_to_load
		 


func _on_New_Game_Button_pressed():
	get_tree().change_scene("res://GAME.tscn") 
