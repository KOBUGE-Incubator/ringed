
extends Control

# ACTIONS inputs
const INPUT_ACTIONS = ["left","right","up","down","run","dodge","shot"] # This array will give us the order and action name in UI too

# Member Variables
var action_used
var button
var control_input_id

# Global Settings
var global 

func _ready():
	global = get_node("/root/global")
	# Options/Controls actions
	control_input_id = 1 # We use it to iterate all the controls nodes in Menu/Controls/InputXXX
	for action in self.INPUT_ACTIONS:
		var input_label = get_node("Input"+str(control_input_id)+"/label")
		var input_button = get_node("Input"+str(control_input_id)+"/button")
		var input_type = InputMap.get_action_list(action)[0].type
		var button_text = ""
		if(input_type == 1): # It is a key type
			button_text = OS.get_scancode_string(InputMap.get_action_list(action)[0].scancode)
		elif(input_type == 3): # It is a mouse button type
			button_text = "Mouse "+str(InputMap.get_action_list(action)[0].button_index)
		input_label.set_text(action+":")
		input_button.set_text(button_text)
		input_button.connect("pressed", self, "wait_for_input", [ control_input_id , action])
		control_input_id += 1

### Keybindings management

func wait_for_input(id, action):
	action_used = action
	button = get_node("Input"+str(id)+"/button")
	control_input_id = id
	set_process_input(true)

func _input(event):
	if (event.type == InputEvent.KEY):
		set_process_input(false)
		button.set_text(OS.get_scancode_string(event.scancode))
		change_key(control_input_id, event)
		button.release_focus()
	if (event.type == InputEvent.MOUSE_BUTTON):
		set_process_input(false)
		button.set_text("Mouse "+str(event.button_index))
		change_key(control_input_id, event)
		button.release_focus()
func change_key(id, event):
	InputMap.erase_action(action_used)
	InputMap.add_action(action_used)
	InputMap.action_add_event(action_used, event)
	global.save_to_config("actions", action_used, event)
	
#	print(InputMap.get_action_list(action_used)[0])
#	InputMap.action_add_event(action_used, event)
#	InputMap.action_erase_event(action_used, InputMap.get_action_list(action_used)[0])



