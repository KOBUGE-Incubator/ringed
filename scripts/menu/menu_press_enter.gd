
extends Control

var animations
var menus
var background

func _ready():
	animations = get_node("AnimationPlayer")
	menus = get_node("../SubMenus")
	background = get_node("../../Background")
	menus.hide()
	animations.play("press_enter_idle")
	set_process_input(true)

func _input(event):
	if(Input.is_action_pressed("ui_accept")):
		set_process_input(false)
		animations.connect("finished", self, "go_to_main_menu")
		animations.play("press_enter_done")


func go_to_main_menu():
	background.make_unfocus()
	self.hide()
	menus.show()
	menus.get_node("Main").make_entrance()
	self.queue_free()