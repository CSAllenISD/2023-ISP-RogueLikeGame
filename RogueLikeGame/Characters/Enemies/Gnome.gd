extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var DAMAGE = 20
export var MAX_HEALTH = 100
onready var stats = $Stats
#onready var health = stats.health
onready var health = MAX_HEALTH
onready var playerdetectionzone = $PlayerDetectionZone
var hitstun = 0
var knockback = Vector2.ZERO
var knockbackSpeed = 100
var velocity = Vector2.ZERO

enum {
	IDLE,
	
	WANDER,
	
	CHASE
	
}
var state = CHASE

func _physics_process(delta):
	if hitstun > 0:
		hitstun -= 1 
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if health <= 0:
		queue_free()
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerdetectionzone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

	velocity = move_and_slide(velocity)
			
func seek_player():
	if playerdetectionzone.can_see_player():
		state = CHASE
func _on_Hurtbox_area_entered(area):
	hitstun = 50
	knockback = global_position - area.global_position
	knockback = (knockback.normalized() * knockbackSpeed) 
	#$Hurtbox.set_deferred("monitoring", false)
	$death.play()



######HITBOX AND HIT COOLDOWN##############
func _on_Hitbox_body_entered(body):
	
	body.health -= DAMAGE
	$HitCooldown.start()
	$Hitbox.monitoring = false
	knockback = global_position - body.global_position
	knockback = (knockback.normalized() * knockbackSpeed * 1.5)
	
	
func _on_HitCooldown_timeout():
	$Hitbox.monitoring = true
	
###########################################
