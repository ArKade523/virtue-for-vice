extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body is CharacterBody2D and _all_enemies_defeated():
		change_tile(sprite.texture.atlas, Rect2(144, 48, 16, 16))
		var next_scene = GameState.get_next_level(get_tree().current_scene.name)
		if next_scene:
			get_tree().change_scene_to_packed(next_scene)

func _all_enemies_defeated() -> bool:
	# Check if there are any enemies left in the current scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	return enemies.size() == 0  # Return true if no enemies exist


func change_tile(tileset_texture: Texture2D, new_region: Rect2):
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = tileset_texture  # Assign the full tileset texture
	atlas_texture.region = new_region  # Define which part of the texture to use

	sprite.texture = atlas_texture  # Apply it to the Sprite2D
