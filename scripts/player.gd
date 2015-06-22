# player.gd -> living_object.gd -> moveable_object.gd -> RigidBody2D
extends "living_object.gd" # The player is alive

export var shot_cooldown = 0.2 # Time between two auto-shots
export var gun_change_cooldown = 0.2 # Time between two auto-bombs
export var dodge_cooldown = 0.5 # Time between two dodges
var bullet_scn = preload("res://scenes/bullet.xml") # The bullet scene
var bomb_scn = preload("res://scenes/bomb.xml") # The bomb scene
var mouse_pos = Vector2(0, 0) # The position of the mouse on the screen
var relative_mouse_pos = Vector2(0, 0) # The position of the mouse in relation to 0,0
var bullet_offset = Vector2(0, 0) # The offset of the bullet (taken from the "Bullet" node)
var time_for_next_shot = 0.0 # How much time is left till the next shot?
var time_for_next_gun_change = 0.0 # How much time is left till the next gun change?
var time_for_next_dodge = 0.0
var camera_shake_time_left = 0.0 # How much time is left before the shake stops?
var camera_shake_distance = 0.0 # The range of the shake
var current_gun = 0 # The ID of the current gun
var current_gun_node # The node of that gun
var switch_weapon = 0 # -1 if we need to switch to the previous weapon, +1 for the next, and 0 otherwise
var gunSounds # The sounds of the guns
var stepSounds # The sounds of the steps
var playerSounds # The sounds that the player make
var light # The main light of the player / for the shadows
var light2 # This doesn't porject shadows
var initial_light_energy # The max energy of the main light
var gun_sound_delay = 0
var speed_run # The speed of the player to run
var speed_dodge # The speed of the player to dodge
var speed_holder # We use it when override the original speed, to reset its value to the original one
var prev_dodge = false # if the player did a previous dodge, so he just can pres and release

func _ready():
	speed_run = speed*2
	speed_dodge = speed*26
	speed_holder = speed
	get_node("AnimationPlayer").play("light")
	current_gun_node = get_node("Guns").get_child(current_gun)
	light = get_node("Light2D")
	light2 = get_node("Light2D2")
	initial_light_energy = light.get_energy()
	gunSounds = get_node("GunSounds") # We use this node to get the gun sounds
	stepSounds = get_node("StepsSounds") # We use this node to get the steps sounds
	playerSounds = get_node("PlayerSounds") #We use this node to get all the sounds that the player make
	set_process(true) # We use _process to offset the mouse
	set_process_input(true) # We use _input to get the mouse position
	Input.set_mouse_mode(1) # Hide the mouse

func _process(delta):
	if(!self.isMoving()): # If the player is not moving, the steps will stop
		stepSounds.stop_voice(0);
	if(self.health == self.max_health): # If we have all the health, the light is active 
		light.set_energy(initial_light_energy)
		light2.set_energy(initial_light_energy)
	else:
		var div = self.max_health / self.health
		var energy = initial_light_energy/div
		light.set_energy(energy)
		light2.set_energy(energy)
	
	var offset = -get_viewport().get_canvas_transform().o # Get the offset
	relative_mouse_pos = mouse_pos + offset # And add it to the mouse position
	if(camera_shake_time_left > 0):
		camera_shake_time_left = camera_shake_time_left - delta
		camera_shake_distance = lerp(camera_shake_distance,0,2 * delta) # Decrease the distance
		var x_shake = rand_range(-1,1) * camera_shake_distance # Offset in x direction
		var y_shake = rand_range(-1,1) * camera_shake_distance # Offset in y direction
		get_node("Camera2D").set_offset(Vector2(x_shake,y_shake)) # Set the offset of the camera
	else:
		camera_shake_time_left = 0.0 # Make it zero
		get_node("Camera2D").set_offset(Vector2(0,0)) # Reset the offset of the camera

func _input(event):
	if(event.type == InputEvent.MOUSE_MOTION): # When we move the mouse
		mouse_pos = event.pos # We change the position of it
	if(event.type == InputEvent.MOUSE_BUTTON): # When we click the mouse
		if(event.button_mask & 16): # Scroll up
			switch_weapon = 1
		elif(event.button_mask & 8): # Scroll down
			switch_weapon = -1

func logic(delta): # We override the function defined in moveable_object.gd
	time_for_next_shot -= delta # We decrease the time till the next shot by the time elapsed
	time_for_next_gun_change -= delta # We decrease the time till the next gun change by the time elapsed
	time_for_next_dodge -= delta # We decrease the time till the next dodge by the time elapsed
	force = Vector2(0,0) # Then we reset the force
	speed = speed_holder # Then we reset the speed 
	# We add a vector to the force depending of the direction in which we move
	if(Input.is_action_pressed("D")):
		force += Vector2(1,0)
		if(!stepSounds.is_voice_active(0)): # If the sound is now stoped
			stepSounds.play("grass_steps") # The sound of the steps in grass
	if(Input.is_action_pressed("A")):
		force += Vector2(-1,0)
		if(!stepSounds.is_voice_active(0)): # If the sound is now stoped
			stepSounds.play("grass_steps") # The sound of the steps in grass
	if(Input.is_action_pressed("S")):
		force += Vector2(0,1)
		if(!stepSounds.is_voice_active(0)): # If the sound is now stoped
			stepSounds.play("grass_steps") # The sound of the steps in grass
	if(Input.is_action_pressed("W")):
		force += Vector2(0,-1)
		if(!stepSounds.is_voice_active(0)): # If the sound is now stoped
			stepSounds.play("grass_steps") # The sound of the steps in grass
	if(Input.is_action_pressed("shift")):
		speed = speed_run # We modify the speed to run
	var dodge = Input.is_action_pressed("spacebar") 
	if(dodge and not prev_dodge):
		do_dodge()
	prev_dodge = dodge # With this we can ensure a dodge and need to release the key
	if(Input.is_key_pressed(InputEvent.NONE)):
		print("nothing")
		stepSounds.stop_all()
		# If we are pressing "shoot" and we have no cooldown left
	if(Input.is_action_pressed("Shot")):
		current_gun_node.shot()
		if(current_gun == 0): # If is the gun 1 that is fired
			if gun_sound_delay == 0:
				gunSounds.play("gun1") # Reproduces the gun 1 sound
			gun_sound_delay += 1
			if gun_sound_delay > 6:
				gun_sound_delay = 0
	else:
		gun_sound_delay = 0
	
	# If we are pressing "Next Weapon" and we have no cooldown left
	if(Input.is_action_pressed("Next_weapon") && time_for_next_gun_change <= 0):
		switch_weapon = 1
	if(Input.is_action_pressed("Prev_weapon") && time_for_next_gun_change <= 0):
		switch_weapon = -1
	if(switch_weapon != 0):
		var guns = get_node("Guns").get_child_count() # The amount of guns we have
		current_gun_node.hide() # Hide the current gun
		current_gun = (current_gun + switch_weapon + guns) % guns # Switch
		current_gun_node = get_node("Guns").get_child(current_gun) # Take the gun
		current_gun_node.show() # Show it
		time_for_next_gun_change = gun_change_cooldown # To prevent ultra-fast change
		switch_weapon = 0 # To prevent locking
	
	target_angle = get_pos().angle_to_point( relative_mouse_pos ) + deg2rad(0) # Set the angle in which the player looks
	
	get_node("../cursor").set_pos(relative_mouse_pos) # Move the cursor

func do_dodge(): # Function to make and watch dodge delay
	if(time_for_next_dodge <= 0):
		speed = speed_dodge # We modify the speed to dodge
		time_for_next_dodge = dodge_cooldown # To prevent ulta move faster with dodge
	
	
func amount_of_damage(from): # We override the function defined in living_object.gd
	if(from != "player"): # Don't receive self-damage
		return 1.0
	return 0

func die(): # We override the function defined in living_object.gd
	set_layer_mask(0) # Disable Collisions
	set_collision_mask(0) # Disable Collisions
	playerSounds.play("die_scream") # Play the scream sound 
	get_node("AnimationPlayer").play("die")
	Input.set_mouse_mode(0) # Show the mouse
	#get_tree().set_pause(true)
	get_node("../CanvasLayer 2/death_screen").show()

func camera_shake(intensity, explosion_pos, explosion_range, time): # Will shake the camera
	var explosion_distance = (get_pos()-explosion_pos).length()
	camera_shake_distance = max((explosion_range - explosion_distance)/explosion_range, 0) # Clam it so it isn't less than 0
	camera_shake_distance += camera_shake_distance * intensity # Increase the shake distance
	camera_shake_time_left += time # Increase the shake time
	
