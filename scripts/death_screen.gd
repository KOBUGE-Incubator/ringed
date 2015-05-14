
extends Control



func _ready():
	connect("input_event", self, "input_event") # Wire things up

func input_event(ev):
	if(ev.type == InputEvent.MOUSE_BUTTON):
		hide()
		get_tree().set_pause(false)
		Input.set_mouse_mode(3) # Hide the mouse
