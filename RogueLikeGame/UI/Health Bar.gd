extends TextureProgress


func _process(delta):
	var whitebar = $WhiteBar.value
	set_process(true)
	if Input.is_action_just_pressed("attack"):
		value -= 10
		whitebar = $WhiteBar.value 
	if value <=0:
		get_tree().change_scene("res://RogueLikeGame/titleScreen.tscn")

	
	
	 
	
