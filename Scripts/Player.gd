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
	
	if (input_direction.x > 0):
		$AnimatedSprite2D.play("walk_right")
	elif  (input_direction.x < 0):
		$AnimatedSprite2D.play("walk_left")
	
		
	
	#Move
	move_and_slide()
	
	#TODO need to add actions for attack and possible roll? Do I do that here?
