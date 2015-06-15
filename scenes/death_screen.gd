
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	set_process_input(true) # We need to detect the user click 
	pass

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON): # When we click the mouse
		if(!self.is_hidden()): # If the death screen is display
			print("mouse click")
			get_tree().change_scene("res://scenes/game.xml")
			
	# si esta visible
	# si-si se hace click se obtiene la escena padre y se resetea
	# no-no pasa nada


