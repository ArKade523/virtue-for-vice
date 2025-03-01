extends CharacterBody2D
# player variables and constants
var move_animations:Array = ["walk_up", "walk_down", "walk_left", "walk_right"]
	

#player blue states
const MOVEMENT_SPEED = GameState.MOVEMENT_SPEED
var is_attacking = false
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var direction_facing = 0 #up=0,down=1,left=2,right=3
var blue_attack_inprogress = false

var damage = 5


func _physics_process(delta):	
	enemy_attack(damage)
	
	if GameState.blue_health <= 0:
		GameState.blue_is_alive = false
		GameState.blue_health = 0
		print("Player Blue has been killed...")
		#TODO add stuff to respawn
	
	if !is_attacking: # If attacking, do not change the animation
		# Get the input direction and handle the movement/deceleration.
		var input_direction = Vector2(
			Input.get_action_strength("blue_right")- Input.get_action_strength("blue_left"),
			Input.get_action_strength("blue_down") - Input.get_action_strength("blue_up")
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
		#Update Movement Speed
		velocity = input_direction * MOVEMENT_SPEED

	#Attack Animations and logic
	if Input.is_action_just_pressed("blue_attack"):
		play_attack_animation()
	

	#Move
	move_and_slide()

func play_attack_animation():
	is_attacking = true
	GameState.blue_current_attacking = true
	blue_attack_inprogress = true
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
	
func blue_player():
	pass

func player_blue_attack():
	print("took damage from blue player")
	GameState.player_blue_heal

func enemy_attack(damage):
	if enemy_in_attack_range and enemy_attack_cooldown:
		GameState.blue_health -= damage
		enemy_attack_cooldown = false
		print(GameState.blue_health)
		$attack_cooldown.start() 

func _on_player_hit_body_entered(body: Node2D) -> void:
	if body.has_method("enemy") or body.has_method("enemy-player"):
		enemy_in_attack_range = true
	if body.has_method("firebolt"):
		damage = GameState.FIREBOLT_DAMAGE

func _on_player_hit_body_exited(body: Node2D) -> void:
	if body.has_method("enemy") or body.has_method("enemy-player"):
		enemy_in_attack_range = false

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
