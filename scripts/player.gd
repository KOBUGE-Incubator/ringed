# player.gd -> living_object.gd -> moveable_object.gd -> RigidBody2D
extends "living_object.gd" # The player is alive

export var shot_cooldown = 0.2 # Time between two auto-shots
var bullet_scn = preload("res://scenes/bullet.xml") # The bullet scene
var mouse_pos = Vector2(0, 0) # The position of the mouse on the screen
var relative_mouse_pos = Vector2(0, 0) # The position of the mouse in relation to 0,0
var bullet_offset = Vector2(0, 0) # The offset of the bullet (taken from the "Bullet" node)
var time_for_next_shot = 0.0 # How much time is left till the next shot?

func _ready():
	bullet_offset = get_node("Bullet").get_pos() # We need the position of the tip of the rifle
	
	set_process(true) # We use _process to offset the mouse
	set_process_input(true) # We use _input to get the mouse position
	
	Input.set_mouse_mode(1) # Hide the mouse
	

func _process(delta):
	var offset = -get_viewport().get_canvas_transform().o # Get the offset
	relative_mouse_pos = mouse_pos + offset # And add it to the mouse position

func _input(event):
	if(event.type == InputEvent.MOUSE_MOTION): # When we move the mouse
		mouse_pos = event.pos # We change the position of it

func logic(delta): # We override the function defined in moveable_object.gd
	time_for_next_shot -= delta # We decrease the time till the next shot by the time elapsed
	force = Vector2(0,0) # Then we reset the force
	# We add a vector to the force depending of the direction in which we move
	if(Input.is_action_pressed("D")):
		force += Vector2(1,0)
	if(Input.is_action_pressed("A")):
		force += Vector2(-1,0)
	if(Input.is_action_pressed("S")):
		force += Vector2(0,1)
	if(Input.is_action_pressed("W")):
		force += Vector2(0,-1)
	# If we are pressing "shoot" and we are 
	if(Input.is_action_pressed("Shot") && time_for_next_shot <= 0):
		var bullet = bullet_scn.instance() # We instance the bullet scene
		get_parent().add_child(bullet) # Then we add it to the scene
		bullet.set_pos(get_pos() + bullet_offset.rotated(get_rot())) # We move the bullet to the right position
		bullet.angle = get_rot() + deg2rad(180) # We set its course
		bullet.source = "player" # The player shoots the bullet
		time_for_next_shot = shot_cooldown # To prevent ultra-fast fire
	
	target_angle = get_pos().angle_to_point( relative_mouse_pos ) + deg2rad(0) # Set the angle in which the player looks
	
	get_node("../cursor").set_pos(relative_mouse_pos) # Move the cursor

func amount_of_damage(from): # We override the function defined in living_object.gd
	if(from != "player"): # Don't receive self-damage
		return 1.0
	return 0

func die(): # We override the function defined in living_object.gd
	get_tree().set_pause(true) # Pause the game when dead

