extends Area2D
#players
var teal_in_attack_zone = false
var blue_in_attack_zone = false
const SPEED = 300  # Adjust as needed
var direction = Vector2.ZERO  # This will be set when fired

func _process(delta: float) -> void:
	position += direction * SPEED * delta

func initialize_fireBolt(dir: Vector2) -> void:
	direction = dir.normalized()  # Ensure it's a unit vector

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.take_damage(GameState.FIREBOLT_DAMAGE)
	self.queue_free()
