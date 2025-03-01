extends CharacterBody2D
# player variables and constants
const MOVEMENT_SPEED = 100.0
var is_attacking = false
var move_animations:Array = ["walk_up", "walk_down", "walk_left", "walk_right"]
var direction_facing = 0 #up=0,down=1,left=2,right=3
@export var inventory:Inventory

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
		#Vector2(0,0):
			#$AnimatedSprite2D.pause()
	
	#Attack Animations and logic
	if Input.is_action_just_pressed("attack"):
		
		print("attack")
		#$AnimatedSprite2D.play("attack_right")
		match direction_facing:
			0: #facing up
				$AnimatedSprite2D.play("attack_up")
			1: #facing down
				$AnimatedSprite2D.play("attack_down")
			2: #facing left
				$AnimatedSprite2D.play("attack_left")
			3: #facing right
				$AnimatedSprite2D.play("attack_right")
		is_attacking = true
					
	#Move
	move_and_slide()
	
	#TODO need to add actions for attack and possible roll? Do I do that here?
