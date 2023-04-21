extends RigidBody2D
export var LIFESPAN = 30
export var DAMAGE = 1000
func _process(delta):
	LIFESPAN -= 1
	if LIFESPAN <= 0:
		queue_free()





func _on_Hitbox_body_entered(body) -> void:
	if body.has_method("_on_Hurtbox_area_entered"):
		body.health -= 50
		
		
		queue_free()
