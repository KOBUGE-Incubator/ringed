extends Node2D
#export var day = false
var time = 3 # The time after we spawned the last spider
var enemy_scn = load("res://scenes/enemy_1.xml") # The spider scene
var background # The grass node
var offset = Vector2(0,0)# The offset of the background
var autoload # The autoload node
var map
var modulate_scene # The actual canvas modulate for the scene
var day_night = preload("day_night.gd")
var day_night_object
export var fake_server_hour = 0
export var fake_server_minutes = 0
export var fake_server_day = 0
var day_time_label
var day_label

func _ready():
	randomize() # Randomize the seed for all random functions
	autoload = get_node("/root/autoload")
	background = get_node("background") # Take the background node
	set_process(true) # We use _process to move the background
	
	# Load the map
	map = autoload.map_scene
	var map_node = map.instance()
	map_node.set_name("Map")
	add_child(map_node)
	modulate_scene = get_node("CanvasModulate")
	get_node("player").set_pos(map_node.get_node("Spawn").get_pos())
	#if (day == true): # If day is true the scene will be in day if not... you know
	#	modulate_scene.set_color(Color(.7,.7,.7))
	#else:
	#	modulate_scene.set_color(Color(.2,.2,.2))
	day_time_label = get_node("HUD/day_time")
	day_label = get_node("HUD/day")
	day_night_object = day_night.new(modulate_scene,fake_server_hour,fake_server_minutes,fake_server_day)
	day_time_label.set_text(day_night_object.what_time_is())
	day_label.set_text("DAY "+str(day_night_object.what_day_is()))
func _process(delta):

	if(fake_server_minutes >60):
		fake_server_minutes = 0
	else:
		fake_server_minutes += 1
	day_night_object.set_mins(fake_server_minutes)
	day_time_label.set_text(day_night_object.what_time_is())
	day_label.set_text("DAY "+str(day_night_object.what_day_is()))
	var background_rect = get_viewport_rect() # The viewport rect
	var offset = get_viewport().get_canvas_transform().o
	background_rect.pos = -offset # The offset of the viewport
	background_rect.size = background_rect.size * 2
	background.set_region_rect(background_rect) # Set the region of the background
	background.set_offset(-offset- background_rect.size/2)
	
