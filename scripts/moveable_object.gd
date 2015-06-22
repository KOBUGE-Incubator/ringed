# moveable_object.gd -> RigidBody2D
extends RigidBody2D

export var infinite_stamina = true # If this option is false, the scene tree needs the nodes StaminaHolder/StaminaBar and StaminaHolder
export var stamina_cooldown = 0.2 # Time between two succesive stamina-recover, or between a run and and stamina-recover
export var max_stamina = 6.0 # The maximum amount of stamina the creature can have
var stamina # The amount of stamina
export var hide_staminabar_when_full = false # Should we hide the stamina bar when it is full?
var staminabar # The staminabar node
var staminabar_region # The original region rect of the staminabar
var staminabarHolder # The node that holder the staminabar (used for rotation)
var time_for_next_stamina_recover = 0.0 # Time left till the next stamina-recover
var is_tired = false # To know if the object is tired
export var speed = 700.0 # The speed with which the object moves
export var rotation_speed = 1000.0 # The speed with which it rotates (100.0 is usually enough, but still...)
var force = Vector2(0, 0) # The force of movement
var target_angle = 0.0 # The angle we want to look at

func _ready():
	if (infinite_stamina == false): # We have to use stamina nodes
		staminabar = get_node("StaminaHolder/StaminaBar")
		staminabarHolder = get_node("StaminaHolder")
		stamina = max_stamina # Reset the stamina
		staminabar_region = staminabar.get_region_rect() # Get the current region rect
		if(hide_staminabar_when_full):
			staminabarHolder.hide() # Hide the staminabar
		else:
			staminabarHolder.show() # Show the staminabar
	set_fixed_process(true) # We use _fixed_process to move
	set_process(true) # We use _process for rotation of the staminabar, so it remains upright

func _process(delta):
	if(infinite_stamina == false):
		staminabarHolder.set_rot(-get_rot()) # Just rotate in the opposite direction to get back to 0 degrees

func _fixed_process(delta):
	if(infinite_stamina == false): # If the object has infinite stamina it wont access to the stamina-recover functions
		time_for_next_stamina_recover -= delta # We decrease the time till the next stamina-recover by the time elapsed
		if(time_for_next_stamina_recover <= 0):
			recover(1)# Auto-recover the creature
			time_for_next_stamina_recover = stamina_cooldown # We restart the auto-heal timer
	
	logic(delta) # Use the logic function to change the force and target angle
	
	if(force.length_squared() > 1): # When we try to move with a force greater than one (length_squared is used because it is faster) 
		force = force.normalized() # Normalize the force vector, so its length equals one
	
	set_linear_velocity(get_linear_velocity() + force * speed * delta) # Move The object
	
	# Interpolate the angle
	var t_dir = Vector2(0,1).rotated(target_angle) # We make a unit vector (one that has a length of one) poiting in the final direction
	var c_dir = Vector2(0,1).rotated(get_rot()) # Then we make another unit vector in the wanted direction
	c_dir = c_dir.linear_interpolate(t_dir, min(rotation_speed * delta, 1)) # We interpolate between them
	set_rot(atan2(c_dir.x,c_dir.y)) # Then we use the angle of the interpolated vector as the rotation

func recover(amount):
	stamina = min(stamina + amount, max_stamina) # Make sure not to get over max_stamina
	update_stamina() # Update the staminabar

func update_stamina(): # Update the staminabar (or will be empty)
	var new_region = staminabar_region # Take the original region
	new_region.size.x *= stamina/max_stamina # Resize the region on X
	staminabar.set_region_rect(new_region) # Apply the new region
	if(stamina <= 0):
		tired(true) # Can move or dodge at full speed
	else:
		tired(false) # The object is not tired now
	if(hide_staminabar_when_full && stamina >= max_stamina): # When we should hide the staminabar, and we have full stamina
		staminabarHolder.hide() # Hide
	else:
		staminabarHolder.show() # Show

func tired(state):
	is_tired = state

func use_stamina (amount):
	if(amount != 0):
		stamina =  max(stamina - amount , -0.1) # Make sure not to get under 0
		time_for_next_stamina_recover = stamina_cooldown # Reset the auto-recover timer
		update_stamina() # Update the staminabar
		return true # Say that the creature use stamina
	return false # Say that the use of stamina attempt was unsuccessful 

func logic(delta):
	pass # Do absolutely nothing
func isMoving():
	if(force == Vector2(0,0)):
		return 0
	return 1

