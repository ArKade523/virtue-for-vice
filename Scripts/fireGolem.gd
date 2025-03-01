extends CharacterBody2D

#creature stats
const MOVEMENT_SPEED = 100
var health = 140

@onready var timer = $Timer
@onready var locator = $locator
@onready var range = $range
@onready var fireBolt = preload("res://Scenes/fireBolt.tscn")
#players
var teal_in_attack_zone = false
var blue_in_attack_zone = false


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

	
func deal_with_damage():
	if (teal_in_attack_zone and GameState.teal_current_attacking) or (blue_in_attack_zone and GameState.blue_current_attacking):
		health -= GameState.BASE_DAMAGE
		print("Golem health =", health)
		if health <= 0:
			self.queue_free()


func _on_enemy_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = true
	

func _on_enemy_hit_box_body_exited(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = false
