extends Control

#@onready var inventory:Inventory = preload("res://inventory/player_blue_inventory.tres")
#@onready var inventory:Inventory = preload("res://inventory/player_teal_inventory.tres")
@onready var slots:Array = $NinePatchRect/GridContainer.get_children()
var is_open = false 

#Ready function is how you do stuff on game startup (I think)
func _ready():
	#update_slots()
	close_inventory()
	
#func update_slots():
	#for i in range(min(inventory.items.size(), slots.size())):
		#slots[i].update(inventory.items[i])
	
#_process function is how you grab input
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
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
	
