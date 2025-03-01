extends Control

@onready var label = $Label
var story = "Another grueling experience behind them, the twins ventured towards their final threat, the demon himself. Would they be able to defeat him? Would the princess even recognize what they'd become? Would they recognize themselves?   "
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print("koko dayo")
	if len(story) <= 1:
			GameState.load_next_level()
	label.text += story[0]
	story[0] = ""
