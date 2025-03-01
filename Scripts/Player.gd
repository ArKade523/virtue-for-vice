extends CharacterBody2D


const MOVEMENT_SPEED = 300.0

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var hor_direction = Input.get_axis("ui_left", "ui_right")
	var ver_direction = Input.get_axis("ui_up", "ui_down")
	if hor_direction:
		velocity.x = hor_direction * MOVEMENT_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MOVEMENT_SPEED)
	if ver_direction:
		velocity.y = ver_direction * MOVEMENT_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, MOVEMENT_SPEED)

	move_and_slide()
