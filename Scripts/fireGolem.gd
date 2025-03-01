extends CharacterBody2D


const MOVEMENT_SPEED = 100

@onready var timer = $Timer
@onready var locator = $locator
@onready var range = $range
@onready var fireBolt = preload("res://Scenes/fireBolt.tscn")


var x_mov = 0
var y_mov = 0


func _process(delta):
	velocity.x = x_mov
	velocity.y = y_mov
	var result: Array = locator.collision_result
	if not result.is_empty():
		update_direction(Vector2(result[0].point.x - position.x, result[0].point.y - position.y))	
	move_and_slide()

func update_direction(direction):
	var angle = direction.normalized()
	if range.is_colliding():
		var result: Array = locator.collision_result
		if not result.is_empty():
			x_mov = angle.x * MOVEMENT_SPEED * -1
			y_mov = angle.y * MOVEMENT_SPEED * -1
	elif direction.length() < 70:
		x_mov = 0
		y_mov = 0
	else:
		x_mov = angle.x * MOVEMENT_SPEED
		y_mov = angle.y * MOVEMENT_SPEED
	range.target_position.x = angle.x * 50
	range.target_position.y = angle.y * 50

func _on_timer_timeout():
	print("YOU WORKING?")
	projectile()
	
	
func projectile():
	var result: Array = locator.collision_result
	if not result.is_empty():
		var bullet = fireBolt.instantiate()
		bullet.position = position  # Spawn at character's position
		var direction = (result[0].point - position).normalized()  # Get direction
		bullet.rotation = direction.angle()  # Rotate the bullet properly
		bullet.initialize_fireBolt(direction)  # Ensure it moves in the right direction

		
		
		get_parent().add_child(bullet)  # Add to the scene
	
