extends CharacterBody2D
# player variables and constants
const MOVEMENT_SPEED = 200.0
@export var inventory:Inventory

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Vector2(
		Input.get_action_strength("right")- Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	
	
	
	
	#Update Movement Speed
	velocity = input_direction * MOVEMENT_SPEED
	match input_direction:
		Vector2(1,0): #moving to the right
			$AnimatedSprite2D.play("walk_right")
		Vector2(-1,0): #moving to the left
			$AnimatedSprite2D.play("walk_left")
		Vector2(0,1): #moving down
			$AnimatedSprite2D.play("walk_down")
		Vector2(0,-1): #moving up
			$AnimatedSprite2D.play("walk_up")
		Vector2(0,0):
			$AnimatedSprite2D.stop()
	#Move
	move_and_slide()
	#$AnimatedSprite2D.stop()
	
	#TODO need to add actions for attack and possible roll? Do I do that here?
