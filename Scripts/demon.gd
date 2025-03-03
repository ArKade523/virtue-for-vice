extends CharacterBody2D

#creature stats
const MOVEMENT_SPEED = 100
var health = 200

@onready var timer = $Timer
@onready var locator = $locator
@onready var range = $range
@onready var default = $default
@onready var right = $right
@onready var charge = preload("res://Scenes/charge.tscn")
@onready var animation = $AnimatedSprite2D
#players
var teal_in_attack_zone = false
var blue_in_attack_zone = false

var x_mov = 0
var y_mov = 0

func _process(_delta):
		deal_with_damage()

func _on_timer_timeout():
	projectile()
	var select = randi_range(0,4)
	
	if select == 0:
		animation.play("right")
	elif select == 1:
		animation.play("left")
	elif select == 2:
		animation.play("back")
	else:
		animation.play("front")


func projectile():
	var source = 0
	var bullet = charge.instantiate()
	if animation.animation == "right":
		source = right.position
	else:
		source = default.position
	
	bullet.position = source
	bullet.rotation = Vector2(randi_range(0,255), randi_range(0,255)).angle()
	add_child(bullet)  # Add to the scene


func deal_with_damage():
	if (teal_in_attack_zone and GameState.teal_current_attacking) or (blue_in_attack_zone and GameState.blue_current_attacking):
		health -= GameState.BASE_DAMAGE
		print("Golem health =", health)
		if health <= 0:
			self.queue_free()

func take_damage(damage: int):
	health -= damage
	# TODO: Add damage animation
	if health <= 0:
		die()

func die():
	# TODO: Add animation
	queue_free()


func _on_enemy_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = true
	

func _on_enemy_hit_box_body_exited(body: Node2D) -> void:
	if body.has_method("teal_player"):
		teal_in_attack_zone = false
