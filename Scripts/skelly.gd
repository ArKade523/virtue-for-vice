extends CharacterBody2D


const MOVEMENT_SPEED = 150

@onready var timer = $Timer
@onready var locator = $Locator
@onready var range = $range

var x_mov = 0
var y_mov = 0

func _process(delta):
	velocity.x = x_mov
	velocity.y = y_mov
	var result: Array = locator.collision_result
	if not result.is_empty():
		update_direction(Vector2(result[0].point.x - position.x ,result[0].point.y - position.y))
		print("collided with: " + str(result[0].point.y))
		print("collided with: " + str(result[0].point.x))		
	move_and_slide()


func _on_timer_timeout():
	if not range.is_colliding():	
		update_direction(Vector2(randi_range(-100, 100), randi_range(-100, 100)))

func update_direction(direction):
	var angle = direction.normalized()
	if range.is_colliding():
		var result: Array = locator.collision_result
		if not result.is_empty():
			x_mov = angle.x * MOVEMENT_SPEED
			y_mov = angle.y * MOVEMENT_SPEED
	x_mov = angle.x * MOVEMENT_SPEED
	y_mov = angle.y * MOVEMENT_SPEED
	view.target_position.x = angle.x * 150
	view.target_position.y = angle.y * 150
