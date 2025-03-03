extends CharacterBody2D

@export_enum("blue", "teal") var pcolor: String

@export_enum("blue_attack", "teal_attack") var attack_input: String
@export_enum("blue_up", "teal_up") var up_input: String
@export_enum("blue_down", "teal_down") var down_input: String
@export_enum("blue_left", "teal_left") var left_input: String
@export_enum("blue_right", "teal_right") var right_input: String

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

	if Input.is_action_just_pressed(attack_input):
		attack()

	# If player dies, reset their health and remove them from the scene
	if GameState.blue_health <= 0:
		die()

	# Player movement
	if not is_attacking:  # If attacking, do not change movement
		var input_direction = Vector2(
			Input.get_action_strength(right_input) - Input.get_action_strength(left_input),
			Input.get_action_strength(down_input) - Input.get_action_strength(up_input)
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
	# TODO: move health into the player
	match pcolor:
		"blue": GameState.blue_current_attacking = true
		"teal": GameState.teal_current_attacking = true
	
	await play_attack_animation()
	# TODO: move health into the player
	match pcolor:
		"blue": GameState.blue_current_attacking = false
		"teal": GameState.teal_current_attacking = false
	is_attacking = false
	

func enemy_attack():
	if enemy_attack_cooldown:
		# TODO: move health into the players
		# Apply enemy attack
		match pcolor:
			"blue": GameState.blue_health -= damage
			"teal": GameState.teal_health -= damage  
		enemy_attack_cooldown = false
		$attack_cooldown.start()  # Start cooldown timer

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true  # Reset cooldown for next attack
	
func die():
	# TODO: move states into player
	match pcolor:
		"blue": 
			GameState.blue_is_alive -= damage
			GameState.blue_health = GameState.MAX_HEALTH
		"teal": 
			GameState.teal_is_alive -= damage 
			GameState.teal_health = GameState.MAX_HEALTH
	
	print("The " + pcolor + " player was killed...")
	queue_free()
