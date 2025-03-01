extends CharacterBody2D

@onready var timer = $Timer
@onready var mikumikubeam = preload("res://Scenes/mikumikubeam.tscn")
@onready var beam_sound = $Beam
var fired = false

func _ready():
	beam_sound.play()  # Add to the scene
	
func _on_timer_timeout():
	#print("YOU WORKING?")
	if not fired:
		projectile()
	else:
		queue_free()


func projectile():
	var bullet_hor = mikumikubeam.instantiate()
	var bullet_ver = mikumikubeam.instantiate()
	bullet_hor.position = position
	bullet_ver.position = position
	bullet_ver.rotation = deg_to_rad(90)
	bullet_hor.rotation = 0
	add_child(bullet_hor)  # Add to the scene
	add_child(bullet_ver)
