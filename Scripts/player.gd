extends CharacterBody2D

@export_enum("blue", "teal") var pcolor: String

@export_enum("blue_attack", "teal_attack") var attack_input: String
@export_enum("blue_up", "teal_up") var up_input: String
@export_enum("blue_down", "teal_down") var down_input: String
@export_enum("blue_left", "teal_left") var left_input: String
@export_enum("blue_right", "teal_right") var right_input: String

@onready var sword_hitbox = $sword_hitbox
@onready var hitbox_up = $sword_hitbox/hitbox_up
@onready var hitbox_down = $sword_hitbox/hitbox_down
@onready var hitbox_left = $sword_hitbox/hitbox_left
@onready var hitbox_right = $sword_hitbox/hitbox_right


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
var direction_facing = UP  # up=0, down=1, left=2, right=3
var damage = 5  # Base damage value

func _ready():
	sword_hitbox.monitoring = false  # Disable hitbox on start
	sword_hitbox.body_entered.connect(_on_sword_hitbox_body_entered)

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
	sword_hitbox.monitoring = true
	enable_correct_hitbox()
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
	sword_hitbox.monitoring = false
	disable_all_hitboxes()
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

func take_damage(damage: int):
	# TODO: Add damage animation
	match pcolor:
		"blue": 
			GameState.blue_health -= damage
			if GameState.blue_health <= 0:
				die()
		"teal": 
			GameState.teal_health -= damage  
			if GameState.teal_health <= 0:
				die()

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true  # Reset cooldown for next attack
	
func _on_sword_hitbox_body_entered(body):
	if body.is_in_group("enemies") or (body.is_in_group("players") and body != self):
		body.take_damage(10)  # Call enemy damage function
	
func enable_correct_hitbox():
	disable_all_hitboxes()  # Turn off all hitboxes first
	match direction_facing:
		UP: hitbox_up.disabled = false
		DOWN: hitbox_down.disabled = false
		LEFT: hitbox_left.disabled = false
		RIGHT: hitbox_right.disabled = false

func disable_all_hitboxes():
	hitbox_up.disabled = true
	hitbox_down.disabled = true
	hitbox_left.disabled = true
	hitbox_right.disabled = true
	
func die():
	# TODO: move states into player
	match pcolor:
		"blue": 
			GameState.blue_is_alive = false
			GameState.blue_health = GameState.MAX_HEALTH
		"teal": 
			GameState.teal_is_alive = false
			GameState.teal_health = GameState.MAX_HEALTH
	
	print("The " + pcolor + " player was killed...")
	queue_free()
