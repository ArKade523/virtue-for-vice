extends Camera2D

@export var player_1: Node2D
@export var player_2: Node2D
@export var min_zoom: float = 3.5  # Closest zoom-in
@export var max_zoom: float = 5.0  # Farthest zoom-out
@export var zoom_speed: float = 5.0  # How fast zoom adjusts
@export var padding: float = 200.0  # Extra space around players

func _process(delta):
	# **Ensure players exist before proceeding**
	var p1 = player_1 if is_instance_valid(player_1) else null
	var p2 = player_2 if is_instance_valid(player_2) else null
	
	#if !GameState.blue_is_alive and !GameState.teal_is_alive:
		#GameState.current_scene -= 1
		#GameState.load_next_level()

	# **Calculate midpoint** (Default to previous position if both players are gone)
	var midpoint: Vector2 = position

	if p1 and p2:
		midpoint = (p1.global_position + p2.global_position) * 0.5
	elif p1:
		midpoint = p1.global_position
	elif p2:
		midpoint = p2.global_position
	
	# **Smoothly move the camera to the midpoint** (+ slight vertical offset)
	position = position.lerp(midpoint, delta)

	# **Calculate distance only if both players exist**
	var distance = 200  # Default zoom distance if one player is missing
	if p1 and p2:
		distance = p1.global_position.distance_to(p2.global_position)

	# **Determine new zoom level based on player distance**
	var screen_size = get_viewport_rect().size
	var desired_zoom = max(
		distance / (screen_size.x - padding),
		distance / (screen_size.y - padding)
	)

	# **Clamp and smoothly adjust zoom**
	var clamped_zoom = clamp(desired_zoom, min_zoom, max_zoom)
	zoom = zoom.lerp(Vector2(clamped_zoom, clamped_zoom), delta * zoom_speed)
