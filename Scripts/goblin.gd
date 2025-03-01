extends CharacterBody2D

const MOVEMENT_SPEED = 150
const DAMAGE = 5
var health = 20


@onready var timer = $Timer
@onready var view = $ShapeCast2D
@onready var animation = $AnimatedSprite2D
@onready var cooldown = $cooldown


var x_mov = 0
var y_mov = 0

func _process(delta):
	velocity.x = x_mov
	velocity.y = y_mov
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			animation.play("right_walk")
		else:
			animation.play("left_walk")
	else:
		if velocity.y > 0:
			animation.play("down_walk")
		else:
			animation.play("up_walk")
	var result: Array = view.collision_result
	if not result.is_empty():
		update_direction(Vector2(result[0].point.x - position.x ,result[0].point.y - position.y))	
	move_and_slide()
	
func enemy():
	pass


func _on_timer_timeout():
	if not view.is_colliding():	
		update_direction(Vector2(randi_range(-100, 100), randi_range(-100, 100)))

func update_direction(direction):
	var angle = direction.normalized()
	x_mov = angle.x * MOVEMENT_SPEED
	y_mov = angle.y * MOVEMENT_SPEED
	view.target_position.x = angle.x * 150
	view.target_position.y = angle.y * 150


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("BIG OOF")
	print(body.name)
	#body.health -= DAMAGE
