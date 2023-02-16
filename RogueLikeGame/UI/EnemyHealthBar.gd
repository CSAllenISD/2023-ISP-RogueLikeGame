extends TextureProgress


func _process(delta):
	max_value = get_parent().get_parent().max_health
	value = get_parent().get_parent().health
	if value <=0:
		get_parent().get_parent().health = 50
