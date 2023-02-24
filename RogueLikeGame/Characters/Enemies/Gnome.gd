extends KinematicBody2D
onready var stats = $Stats
onready var health = stats.health
var hitstun = 0
var knockback = Vector2.ZERO
var knockbackSpeed = 100

func _physics_process(delta):
	if hitstun > 0:
		hitstun -= 1 
	knockback = knockback.move_toward(Vector2.ZERO, 100 * delta)
	knockback = move_and_slide(knockback)
	if health <= 0:
		queue_free()
		
func _on_Hurtbox_area_entered(area):
	hitstun = 50
	knockback = global_position - area.global_position
	knockback = (knockback.normalized() * knockbackSpeed) 
	#$Hurtbox.set_deferred("monitoring", false)
	$death.play()
