extends CharacterBody2D
#players
var teal_in_attack_zone = false
var blue_in_attack_zone = false
const SPEED = 300  # Adjust as needed
var direction = Vector2.ZERO  # This will be set when fired

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = direction * SPEED  # Move in the given direction
		move_and_slide()

func initialize_fireBolt(dir: Vector2) -> void:
	direction = dir.normalized()  # Ensure it's a unit vector


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = true
		GameState.teal_health -= GameState.FIREBOLT_DAMAGE
	if body.has_method("blue_player"):
		blue_in_attack_zone = true
		GameState.blue_health -= GameState.FIREBOLT_DAMAGE
	self.queue_free()
	
