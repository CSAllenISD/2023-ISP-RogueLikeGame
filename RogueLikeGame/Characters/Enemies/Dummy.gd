extends Node2D

func create_dummy_effect():
	
	var DummyEffect = load("res://RogueLikeGame/Effects/DummyEffect.tscn")
	var dummyEffect = DummyEffect.instance()
	var main = get_tree().current_scene
	main.add_child(dummyEffect)
	dummyEffect.global_position = global_position
		#queue_free()


func _on_Hurtbox_area_entered(area):
	print("area")
	create_dummy_effect()
	$Sprite.visible = false
	$AnimatedSprite.play("hitanimate")
	$AnimatedSprite.visible = true
	$HitSound.play()
	


func _on_AnimatedSprite_animation_finished():
	$Sprite.visible = true
	$AnimatedSprite.stop()
	$AnimatedSprite.visible = false
