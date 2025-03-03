extends Area2D
const SPEED = 300 
var direction = Vector2.ZERO 

func _process(delta: float) -> void:
	position += direction * SPEED * delta

func initialize_fireBolt(dir: Vector2) -> void:
	direction = dir.normalized()  # Ensure it's a unit vector

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.take_damage(GameState.FIREBOLT_DAMAGE)
	queue_free()
