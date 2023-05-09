extends Area2D
var EFFECT = load("res://RogueLikeGame/Effects/Attack_speed_up.tscn")
var effect
var main
func _ready():
	self.main = get_parent().get_parent()

func _on_key_body_entered(body):
	#body.keys += 1
	SaveFile.Attack_Speed -= .05
	effect = EFFECT.instance()
	#add_child(effect)
	effect.position = self.position
	main.add_child(effect)
	$keysound.play()
	$CollisionShape2D.disabled = true
	monitoring = false

func _on_keysound_finished():
	queue_free()


func _on_key_body_exited(body):
	queue_free()
