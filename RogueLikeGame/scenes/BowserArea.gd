extends Area2D


func _on_Area2D_body_entered(body):
	$BowserSpeech.queue_text("Ill get those pesky plumbers")
	#$BowserSpeech.show_text_box()
	



func _on_Area2D_body_exited(body):
	$BowserSpeech.change_state($BowserSpeech.State.FINISHED)
	$BowserSpeech.hide_text_box()
	
