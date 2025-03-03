extends Control

@onready var label = $Label
var story = "The first challenge behind, the brothers ventured deeper into the caves. As their hardships increased so did their malice and their resentment for each other. The brothers had long fought for the hand of the maiden and now the opportunity appeared to take the lead...  "
var game_area: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_area = get_tree().get_first_node_in_group("game_area")
	label.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_action_strength("blue_attack"):
		if game_area:
			game_area.load_next_level()


func _on_timer_timeout() -> void:
	if len(story) <= 1 and game_area:
		game_area.load_next_level()
	label.text += story[0]
	story[0] = ""
