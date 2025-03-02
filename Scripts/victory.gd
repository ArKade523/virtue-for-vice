extends Control

@onready var label1 = $Label
@onready var label2 = $Label2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label1.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label1 = "Player1 retained his:\n"
	for item in GameState.blue_attributes:
		label1 += item + "\n"
	label2 = "Player2 retained his:\n"
	for item in GameState.teal_attributes:
		label2 += item + "\n"
