extends Camera2D

@export var player_1: Node2D
@export var player_2: Node2D
@export var min_zoom: float = 2.5  # Closest zoom-in
@export var max_zoom: float = 5.0  # Farthest zoom-out
@export var zoom_speed: float = 5.0  # How fast zoom adjusts
@export var padding: float = 200.0  # Extra space around players

func _process(delta):
	if not (player_1 and player_2):
		return  # If players are missing, do nothing

	# Calculate the midpoint between the two players
	var midpoint = (player_1.global_position + player_2.global_position) * 0.5
	position = position.lerp(midpoint + Vector2(0, -100), delta)   # Smoothly move to midpoint

	# Calculate distance between players
	var distance = player_1.global_position.distance_to(player_2.global_position)

	# Determine new zoom level based on player distance
	var screen_size = get_viewport_rect().size
	var desired_zoom = max(
		distance / (screen_size.x - padding),  # Scale to fit width
		distance / (screen_size.y - padding)   # Scale to fit height
	)

	# Clamp zoom between min and max values
	var clamped_zoom = clamp(desired_zoom, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2(clamped_zoom, clamped_zoom), delta * zoom_speed)
