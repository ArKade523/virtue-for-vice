extends CharacterBody2D

# Creature stats
const MOVEMENT_SPEED = 60
var health = 140

@onready var timer = $Timer
@onready var damage_timer = $DamageTimer  # Timer for controlling damage intervals
@onready var locator = $locator
@onready var range = $range
@onready var fireBolt = preload("res://Scenes/fireBolt.tscn")

# Players
var teal_in_attack_zone = false
var blue_in_attack_zone = false


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

func _ready():
	damage_timer.timeout.connect(_apply_damage)  # Connect timeout signal
var detected_players: Array = []  # Stores players detected in range

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

	if distance > 70:  # Too far → Move closer
		velocity = angle * MOVEMENT_SPEED
	elif distance < 70:  # Too close → Move backward
		velocity = -angle * MOVEMENT_SPEED
	else:  # Just right → move just a tiny bit
		velocity = Vector2(randf_range(-1, 1), randf_range(-1,1)) * MOVEMENT_SPEED / 4

func _on_timer_timeout():
	projectile()

func projectile():
	if detected_players.is_empty():
		return  # No target
	
	var target = detected_players[0]  # Target the first player detected
	var bullet = fireBolt.instantiate()
	bullet.position = position  # Spawn at golem's position
	var direction = (target.global_position - position).normalized()  # Get direction
	bullet.rotation = direction.angle()  # Rotate bullet to face the target
	bullet.initialize_fireBolt(direction)  # Ensure it moves in the right direction
	get_parent().add_child(bullet)  # Add to the scene

func _apply_damage():
	# Only apply damage if the player is attacking
	if (teal_in_attack_zone and GameState.teal_current_attacking) or (blue_in_attack_zone and GameState.blue_current_attacking):
		health -= GameState.BASE_DAMAGE
		print("Golem health =", health)

		# If the golem dies, stop processing damage
		if health <= 0:
			die()
			return

		# Restart the timer **only after dealing damage**
		damage_timer.start()
		
func die():
	# TODO: Add animation
	queue_free()

func _on_locator_body_entered(body: Node2D):
	if body.is_in_group("players"):  # Ensure the body is a player
		detected_players.append(body)

func _on_locator_body_exited(body: Node2D):
	if body.is_in_group("players"):
		detected_players.erase(body)  # Remove the player from tracking list

# Start the damage timer **only when entering the attack zone**
func _on_enemy_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = true
	elif body.has_method("blue_player"):
		blue_in_attack_zone = true

	# If the timer is not already running, start it
	if damage_timer.is_stopped():
		damage_timer.start()

# Stop the timer **only when both players leave**
func _on_enemy_hit_box_body_exited(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = false
	elif body.has_method("blue_player"):
		blue_in_attack_zone = false

	# Stop the timer if no players remain in the attack zone
	if not teal_in_attack_zone and not blue_in_attack_zone:
		damage_timer.stop()
