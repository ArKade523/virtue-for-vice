extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var black_overlay: ColorRect = $CanvasLayer/BlackOverlay

func _ready():
	body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	if _all_enemies_defeated():
		change_tile(sprite.texture.atlas, Rect2(144, 48, 16, 16))
	
func _on_body_entered(body):
	if body is CharacterBody2D and _all_enemies_defeated():
		_fade_to_black(body)
		

func _all_enemies_defeated() -> bool:
	# Check if there are any enemies left in the current scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	return enemies.size() == 0  # Return true if no enemies exist

func _fade_to_black(body):
	black_overlay.position = body.global_position - black_overlay.size / 2
	animation_player.play("fadeOut")

	await animation_player.animation_finished
	var next_scene = GameState.get_next_level(get_tree().current_scene.name)
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)

func change_tile(tileset_texture: Texture2D, new_region: Rect2):
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = tileset_texture  # Assign the full tileset texture
	atlas_texture.region = new_region  # Define which part of the texture to use

	sprite.texture = atlas_texture  # Apply it to the Sprite2D
