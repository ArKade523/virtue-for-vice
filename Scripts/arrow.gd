extends CharacterBody2D

const SPEED = 200

func _process(delta: float) -> void:
	velocity.x = SPEED
	move_and_slide()


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	# Deal damage to thing if player
	queue_free()
