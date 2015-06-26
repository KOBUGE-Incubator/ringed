
extends Control

var checkbox
# Global Settings
var global 

func _ready():
	global = get_node("/root/global")
	checkbox = get_node("Option1/CheckBox")
	checkbox.set_pressed(global.fullscreen)
	checkbox.connect("toggled", self, "set_fullscreen")

func set_fullscreen(flag):
	global.fullscreen = flag
	OS.set_window_fullscreen(global.fullscreen)
	global.save_to_config("display", "fullscreen", flag)