extends Area2D

@export var next_scene: PackedScene

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body is CharacterBody2D and _all_enemies_defeated():
		get_tree().change_scene_to_packed(next_scene)

func _all_enemies_defeated() -> bool:
	# Check if there are any enemies left in the current scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	return enemies.size() == 0  # Return true if no enemies exist
