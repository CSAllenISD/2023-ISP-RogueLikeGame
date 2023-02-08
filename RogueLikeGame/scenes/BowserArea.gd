extends Area2D


func _on_Area2D_body_entered(body):
	$BowserSpeech.show_text_box()
	print("bowserspeech yes")


func _on_Area2D_body_exited(body):
	$BowserSpeech.hide_text_box()
