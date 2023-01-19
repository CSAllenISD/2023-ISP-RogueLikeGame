extends ColorRect

signal fade_finished

func fade_in():
	$AnimationPlayer.play("fade-in")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")


func _on_FadeIn_fade_finished():
	pass # Replace with function body.
