extends CharacterBody2D

# Player variables and constants
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

# Player states
const MOVEMENT_SPEED = GameState.MOVEMENT_SPEED
var is_attacking = false
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var direction_facing = 0  # up=0, down=1, left=2, right=3
var damage = 5  # Base damage value

func _physics_process(delta):	
	# Process enemy attack logic
	if enemy_in_attack_range and enemy_attack_cooldown:
		enemy_attack()

	if Input.is_action_just_pressed("blue_attack"):
		attack()

	# If player dies, reset their health and remove them from the scene
	if GameState.blue_health <= 0:
		die()

	# Player movement
	if not is_attacking:  # If attacking, do not change movement
		var input_direction = Vector2(
			Input.get_action_strength("blue_right") - Input.get_action_strength("blue_left"),
			Input.get_action_strength("blue_down") - Input.get_action_strength("blue_up")
		)

		# Update Movement Speed
		velocity = input_direction.normalized() * MOVEMENT_SPEED

		# Play walking animations
		if input_direction != Vector2.ZERO:
			if input_direction.y < 0:  # Moving up
				direction_facing = UP
			elif input_direction.y > 0:  # Moving down
				direction_facing = DOWN
			elif input_direction.x < 0:  # Moving left
				direction_facing = LEFT
			elif input_direction.x > 0:  # Moving right
				direction_facing = RIGHT
			$AnimatedSprite2D.play(move_animations[direction_facing])
		else:
			$AnimatedSprite2D.stop()  # Stop animation when not moving

	# Move the player
	move_and_slide()

func play_attack_animation():
	var attack_animation = ""
	match direction_facing:
		UP: attack_animation = "attack_up"
		DOWN: attack_animation = "attack_down"
		LEFT: attack_animation = "attack_left"
		RIGHT: attack_animation = "attack_right"

	# Play the chosen attack animation
	$AnimatedSprite2D.play(attack_animation)
	# Wait until animation finishes before allowing movement again
	await $AnimatedSprite2D.animation_finished

func attack():
	is_attacking = true
	GameState.blue_current_attacking = true
	await play_attack_animation()
	GameState.blue_current_attacking = false
	is_attacking = false
	

func enemy_attack():
	if enemy_attack_cooldown:
		GameState.blue_health -= damage  # Apply enemy attack
		enemy_attack_cooldown = false
		$attack_cooldown.start()  # Start cooldown timer

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true  # Reset cooldown for next attack
	
func die():
	GameState.blue_is_alive = false
	GameState.blue_health = GameState.MAX_HEALTH
	print("The blue player was killed...")
	queue_free()
