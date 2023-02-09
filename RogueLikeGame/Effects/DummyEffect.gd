extends Node2D

onready var animatedsprite = $AnimatedSprite

func _ready():
	animatedsprite.frame = 0
	animatedsprite.play("animated")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	queue_free()
