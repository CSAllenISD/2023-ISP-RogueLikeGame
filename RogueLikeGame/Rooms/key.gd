extends Area2D


func _on_key_body_entered(body):
	body.keys += 1
	$keysound.play()
	$CollisionShape2D.disabled = true
	monitoring = false

func _on_keysound_finished():
	queue_free()


func _on_key_body_exited(body):
	queue_free()
