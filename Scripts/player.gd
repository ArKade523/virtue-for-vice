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
var direction_facing = UP  # up=0, down=1, left=2, right=3
var damage = 5  # Base damage value
var health: float = GameState.MAX_HEALTH
var alive: bool = true

func _ready():
	sword_hitbox.monitoring = false  # Disable hitbox on start
	sword_hitbox.body_entered.connect(_on_sword_hitbox_body_entered)

func _physics_process(delta):
	if alive:
		if Input.is_action_just_pressed(attack_input):
			attack()

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

	await play_attack_animation()

	sword_hitbox.monitoring = false
	disable_all_hitboxes()
	is_attacking = false

func take_damage(damage: int):
	# TODO: Add damage animation
	health -= damage
	if health <= 0:
		die()

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
	# TODO: make the player actually disabled fully
	# TODO: Add death animation
	alive = false
	visible = false
	global_position.y += 500 # TEMPORARY LOL but it works tho

func revive():
	# TODO: Add revive animation maybe
	alive = true
	health = GameState.MAX_HEALTH
