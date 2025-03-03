extends CharacterBody2D

# Creature stats
const MOVEMENT_SPEED = 100
const DAMAGE = 2
var health = 20

@onready var timer = $Timer
@onready var hurtbox = $hurtbox
@onready var locator = $locator
@onready var range = $range

var move_animations: Array = [
	"walk_up", 
	"walk_down", 
	"walk_left", 
	"walk_right"
]
const UP = 0
const DOWN = 1
const LEFT = 2
const RIGHT = 3
var direction_facing = DOWN

var wander_timer = 0.0  # Timer to control wandering
var wander_direction = Vector2.ZERO  # Current movement direction

var detected_players: Array = []  # Stores players detected in range
var attackable_players: Array = []  # Stores players detected in range

func _process(delta):
	var direction: Vector2 = Vector2.ZERO
	if detected_players.is_empty():
		direction = wander(delta)
	else:
		var player_pos = detected_players[0].global_position  # Chase the first player
		direction = player_pos - position
		update_direction(direction)
	
	update_animations(direction)
	move_and_slide()
	
func update_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):  # Horizontal movement dominates
			if direction.x > 0:
				direction_facing = RIGHT
			else:
				direction_facing = LEFT
		else:  # Vertical movement dominates
			if direction.y > 0:
				direction_facing = DOWN
			else:
				direction_facing = UP
		$AnimatedSprite2D.play(move_animations[direction_facing])
	else:
		$AnimatedSprite2D.play("walk_down") # TODO: Add idle anim

func wander(delta):
	wander_timer -= delta  # Decrease timer

	if wander_timer <= 0:  # Time to pick a new direction
		wander_timer = randf_range(1.5, 3.5)  # Random interval for movement
		wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	velocity = wander_direction * MOVEMENT_SPEED * 0.5  # Move at 50% speed
	return wander_direction

func update_direction(direction: Vector2):
	var distance = direction.length()
	var angle = direction.normalized()

	velocity = angle * MOVEMENT_SPEED

func _on_timer_timeout():
	attack()

func attack():
	if attackable_players.is_empty():
		return  # No target
	
	var target = attackable_players[0]  # Target the first player detected
	target.take_damage(DAMAGE)

func take_damage(damage: int):
	health -= damage
	# TODO: Add damage animation
	if health <= 0:
		die()

func die():
	# TODO: Add animation
	queue_free()

func _on_hurtbox_body_entered(body: Node2D):
	if body.is_in_group("players"):  # Ensure the body is a player
		attackable_players.append(body)

func _on_hurtbox_body_exited(body: Node2D):
	if body.is_in_group("players"):
		attackable_players.erase(body)  # Remove the player from tracking list

func _on_locator_body_entered(body: Node2D):
	if body.is_in_group("players"):  # Ensure the body is a player
		detected_players.append(body)

func _on_locator_body_exited(body: Node2D):
	if body.is_in_group("players"):
		detected_players.erase(body)  # Remove the player from tracking list
