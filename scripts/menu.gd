
extends Node2D

func _ready():
	get_viewport().connect("size_changed", self, "size_changed") # Update the sizes of different objects
	get_node("Menu/Start").connect("pressed", self, "play") # Connect the play function
	size_changed() # Update

func size_changed():
	var new_size = get_viewport().get_visible_rect().size # The new size
	var background_region = Rect2(0, 0, new_size.x * 2, new_size.y) # Resize the grass background
	get_node("Background/Sprite").set_region_rect(background_region)
	get_node("Menu").set_margin( MARGIN_RIGHT, new_size.x) # Resize the menu on X
	get_node("Menu").set_margin( MARGIN_BOTTOM, new_size.y) # Resize the menu on Y

func play():
	get_tree().change_scene("res://scenes/game.xml")

