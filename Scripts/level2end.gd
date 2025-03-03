extends Control

@onready var label = $Label
var story = "Another grueling experience behind them, the twins ventured towards their final threat, the demon himself. Would they be able to defeat him? Would the princess even recognize what they'd become? Would they recognize themselves?   "
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
