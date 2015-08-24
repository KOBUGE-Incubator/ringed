
extends Node2D

var autoload
var menu

func _ready():
	autoload = get_node("/root/autoload")
	menu = autoload.main_menu
	var menu_node = menu.instance()
	menu_node.set_name("Menu")
	add_child(menu_node)


