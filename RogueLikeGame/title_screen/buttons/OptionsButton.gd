extends Button

export(String) var scene_to_load
	


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://RogueLikeGame/Game/Options.tscn") 
