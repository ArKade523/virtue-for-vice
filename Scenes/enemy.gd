extends CharacterBody2D


@onready var timer = $Timer

var x_mov = 0
var y_mov = 0

func _process(delta):
	velocity.x = x_mov
	velocity.y = y_mov
	
	move_and_slide()


func _on_timer_timeout():
	x_mov = randi_range(-100, 100)
	y_mov = randi_range(-100, 100)
