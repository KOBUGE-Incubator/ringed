
extends Node2D

export var smooth = 8.0
var target

func _ready():
	get_viewport().connect("size_changed", self, "size_changed") # Update the sizes of different objects
	size_changed() # Update
	set_process(true)
	#set_scale(Vector2(0.3, 0.3))
	#set_pos(Vector2(1024/3, 768/3))
	
	# Connect the menu
	target = get_node("Menu/Main")
	get_node("Menu/Main/Join").connect("pressed", self, "move_menu", ["Join"])
	get_node("Menu/Main/Host").connect("pressed", self, "move_menu", ["Host"])
	
	get_node("Menu/Host/Back").connect("pressed", self, "move_menu", ["Main"])
	get_node("Menu/Join/Back").connect("pressed", self, "move_menu", ["Main"])
	
	get_node("Menu/Join/Enter").connect("pressed", self, "join") 
	

func size_changed():
	var new_size = get_viewport().get_visible_rect().size # The new size
	var background_region = Rect2(0, 0, new_size.x * 5, new_size.y * 5) # Resize the grass background
	get_node("Background/Sprite").set_region_rect(background_region)
	get_node("Background/Sprite").set_offset(-2*new_size)
	get_node("Menu").set_margin( MARGIN_RIGHT, new_size.x) # Resize the menu on X
	get_node("Menu").set_margin( MARGIN_BOTTOM, new_size.y) # Resize the menu on Y
	
	# Move sub-menus
	get_node("Menu/Join").set_pos(Vector2(new_size.x, 0))
	get_node("Menu/Host").set_pos(Vector2(0, new_size.y))

func _process(delta):
	var target_pos = -target.get_pos()
	var c_pos = get_pos()
	if(c_pos.distance_squared_to(target_pos) > 2):
		var new_pos = c_pos + (target_pos - c_pos)/smooth
		set_pos(new_pos)

func move_menu(to):
	target = get_node("Menu/" + to)

func join():
	get_tree().change_scene("res://scenes/game.xml")

func play():
	get_tree().change_scene("res://scenes/game.xml")

