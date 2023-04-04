extends RigidBody2D
export var LIFESPAN = 30
export var DAMAGE = 1000
func _process(delta):
	LIFESPAN -= 1
	if LIFESPAN <= 0:
		queue_free()


var creature
func _on_Hitbox_body_entered(body):
	creature = body.get_parent()
	print(creature)
	creature.health -= DAMAGE
