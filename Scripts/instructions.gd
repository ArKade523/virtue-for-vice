extends Control

@onready var label = $Label
var story = "One fateful day, twin brothers were practicing Latin when they accidentally summoned a demon. This demon whisked away their beloved to a horrible dungeon. Before he left, he told them that they had the chance to fight for their beloved. However this dungeon had many perils and each death exchanged a virtue for a vice. Will the twins retain their humanity and save the princess?  "
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
