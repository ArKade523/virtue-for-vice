
extends CharacterBody2D
#players
var teal_in_attack_zone = false
var blue_in_attack_zone = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.take_damage(GameState.FIREBOLT_DAMAGE)
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
