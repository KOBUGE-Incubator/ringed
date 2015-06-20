extends Node2D

var time = 3 # The time after we spawned the last spider
var enemy_scn = load("res://scenes/enemy_1.xml") # The spider scene
var background # The grass node
var offset = Vector2(0,0)# The offset of the background
var autoload # The autoload node
var map

func _ready():
	randomize() # Randomize the seed for all random functions
	autoload = get_node("/root/autoload")
	background = get_node("CanvasLayer/background") # Take the background node
	set_fixed_process(false) # We use _fixed_process to spawn spiders
	set_process(true) # We use _process to move the background
	
	# Load the map
	map = autoload.map_scene
	var map_node = map.instance()
	map_node.set_name("Map")
	add_child(map_node)
	
	get_node("player").set_pos(map_node.get_node("Spawn").get_pos())
	
func _process(delta):
	offset = -get_viewport().get_canvas_transform().o # The offset of the viewport
	var o = offset/Vector2(1024,768) # We divide it by the original screen size, so it will match the UV coordinates of the background sprite
	background.get_material().set_shader_param("Offset",Vector3(o.x,o.y,0)) # Pass the offset to the shader
	background.set_region_rect(get_viewport_rect()) # And set the region of the background

func _fixed_process(delta):
	time += delta # Increase the time left till the next spider by the time elapsed
	if time > 1: # Enough time had passed
		time = 0 # Reset the timer
		var x = 0 # The X position of the new spider
		var y = 0 # The Y position of the new spider
		var side = randi() % 4 # The side on which we will spawn the spider (0-3 => top-right-bottom-left)
		if side == 0: # Choose X and Y for top
			x = randi() % int(get_viewport_rect().size.x)
			y = - 100
		elif side == 1: # Choose X and Y for right
			x = int(get_viewport_rect().size.x) + 100
			y = randi() % int(get_viewport_rect().size.y)
		elif side == 2: # Choose X and Y for bottom
			x = randi() % int(get_viewport_rect().size.x)
			y = int(get_viewport_rect().size.y) + 100
		elif side == 3: # Choose X and Y for left
			x = -100
			y = randi() % int(get_viewport_rect().size.y)
		
		var enemy = enemy_scn.instance() # Instance the enemy scene
		enemy.set_pos(Vector2(x,y) + offset) # Set the position of the enemy
		add_child(enemy) # Add the enemy to the scene