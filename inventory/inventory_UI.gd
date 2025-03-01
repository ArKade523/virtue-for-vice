extends Control

#to check if inventory is open or closed
var is_open = false

#Ready function is how you do stuff on game startup (I think)
func _ready():
	close_inventory()
	
#_process function is how you grab input
func _process(delta: float) -> void:
	if Input.get_action_strength("open_inventory"):
		if is_open:
			close_inventory()
		else:
			open_inventory()
	
	
func open_inventory():
	visible = true
	is_open = true
	
func close_inventory():
	visible = false #hides the inventory UI
	is_open = false
	
