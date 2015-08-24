
extends PopupPanel

var btn_unpause
var btn_view_project
var btn_main_menu

func _ready():
	btn_unpause = get_node("Button")
	btn_view_project = get_node("Label/Button")
	btn_main_menu = get_node("Button2")
	btn_main_menu.connect("pressed", self, "go_to_main_menu")
	btn_view_project.connect("pressed", self, "visit_repo")
	btn_unpause.connect("pressed", self, "unpause")
	set_process_input(true)

func _input(event):
	if(Input.is_action_pressed("ui_cancel")):
		pause(true)

func unpause():
	pause(false)

func pause(flag):
	get_tree().set_pause(flag)
	if(flag):
		self.show()
		Input.set_mouse_mode(0)
	else:
		self.hide()
		Input.set_mouse_mode(1)

func visit_repo():
	OS.shell_open ("https://github.com/KOBUGE-Games/ringed/issues")

func go_to_main_menu():
	pause(false)
	Input.set_mouse_mode(0)
	get_tree().change_scene("res://scenes/menu/menu.xml")
