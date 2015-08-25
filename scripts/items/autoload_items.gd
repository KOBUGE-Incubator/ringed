extends Node2D

var consumable_items = []
var path_consumable_items = "res://scenes/items/consumables/"

func _ready():
	get_folder_scenes(path_consumable_items,consumable_items)

func get_folder_scenes(path,array):
	var dir = Directory.new()
	dir.open(path_consumable_items)
	dir.list_dir_begin()
	var name = dir.get_next()
	while(name):
		if(name.length() > 2):
			if(!dir.current_is_dir()):
				array.append(load(path + name))
		name = dir.get_next()
	dir.list_dir_end()