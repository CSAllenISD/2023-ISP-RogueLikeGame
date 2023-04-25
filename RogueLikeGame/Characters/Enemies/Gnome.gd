extends KinematicBody2D

export(int) var SPEED: int = 40

var path: Array = []	# Contains destination positions
var levelNavigation: Navigation2D = null
var player = null
var player_spotted: bool = false

onready var line2d = $Line2D
onready var los = $LineOfSight

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

func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
enum {
	IDLE,

	WANDER,

	CHASE

}
var state = CHASE

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if hitstun > 0:
		hitstun -= 1 
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if health <= 0:
		queue_free()
	if player:
		los.look_at(player.global_position)
		check_player_in_detection()
		if player_spotted:
			generate_path()
			navigate()
	move()
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
func check_player_in_detection() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted = true
		print("raycast collided")	# Debug purposes
		return true
	return false
func navigate():	# Define the next position to go to
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * SPEED
		
		# If reached the destination, remove this point from path array
		if global_position == path[0]:
			path.pop_front()
func generate_path():	# It's obvious
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
		line2d.points = path
func move():
	velocity = move_and_slide(velocity)

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
