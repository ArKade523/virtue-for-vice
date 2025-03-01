extends Control

@onready var label = $Label
var story = "The first challenge behind, the brothers ventured deeper into the caves. As their hardships increased so did their malice and their resentment for each other. The brothers had long fought for the hand of the maiden and now the opportunity appeared to take the lead...  "
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
