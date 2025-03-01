extends Panel
#This script makes picked up items actually appear in the inventory
@onready var item_visual:Sprite2D = $item_display

func update(item:Inventory_Item):
	if !item: #There is no item there
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
