extends CharacterBody2D

const DAMAGE = 302938
const SPEED = 300  # Adjust as needed
var direction = Vector2.ZERO  # This will be set when fired

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = direction * SPEED  # Move in the given direction
		move_and_slide()

func initialize_fireBolt(dir: Vector2) -> void:
	direction = dir.normalized()  # Ensure it's a unit vector



func _on_area_2d_body_entered(body: Node2D) -> void:
	#body.health -= DAMAGE # Replace with function body.
	print("REECE GOT EM")
	queue_free()
	
