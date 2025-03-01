
extends CharacterBody2D
#players
var teal_in_attack_zone = false
var blue_in_attack_zone = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = true
		GameState.teal_health -= GameState.FIREBOLT_DAMAGE
	if body.has_method("blue_player"):
		blue_in_attack_zone = true
		GameState.blue_health -= GameState.FIREBOLT_DAMAGE
	self.queue_free()

func _on_timer_timeout() -> void:
	queue_free()
