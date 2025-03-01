extends CharacterBody2D
# player variables and constants
const MOVEMENT_SPEED = 100.0
var is_attacking = false
var move_animations:Array = ["walk_up", "walk_down", "walk_left", "walk_right"]
var direction_facing = 0 #up=0,down=1,left=2,right=3
@export var inventory:Inventory

func _physics_process(delta):
	if !is_attacking: # If attacking, do not change the animation
		# Get the input direction and handle the movement/deceleration.
		var input_direction = Vector2(
			Input.get_action_strength("right")- Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		
		#Update Movement Speed
		velocity = input_direction.normalized() * MOVEMENT_SPEED
		
		#Runs the walking animations
		match input_direction:
			Vector2(0,-1): #moving up
				direction_facing = 0
				$AnimatedSprite2D.play(move_animations[0])
			Vector2(0,1): #moving down
				direction_facing = 1
				$AnimatedSprite2D.play(move_animations[1])
			Vector2(-1,0): #moving to the left
				direction_facing = 2
				$AnimatedSprite2D.play(move_animations[2])
			Vector2(1,0): #moving to the right
				direction_facing = 3
				$AnimatedSprite2D.play(move_animations[3])
			Vector2(0,0):
				$AnimatedSprite2D.stop()

	#Attack Animations and logic
	if Input.is_action_just_pressed("attack"):
		play_attack_animation()
	
	#Move
	move_and_slide()

func play_attack_animation():
	is_attacking = true
	var attack_animation = ""
	match direction_facing:
		0: #facing up
			attack_animation = "attack_up"
		1: #facing down
			attack_animation = "attack_down"
		2: #facing left
			attack_animation = "attack_left"
		3: #facing right
			attack_animation = "attack_right"

	# Play the chosen animation
	$AnimatedSprite2D.play(attack_animation)

	# Wait until animation reaches the last frame
	var total_frames = $AnimatedSprite2D.sprite_frames.get_frame_count(attack_animation)
	while $AnimatedSprite2D.frame < total_frames - 1:
		await get_tree().process_frame  # Wait for each frame update

	# Animation finished, return to idle
	is_attacking = false


func _on_sword_hit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		area.take_damage()
