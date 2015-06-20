# bomb.gd -> RigidBody2D
extends RigidBody2D

export var push = 500.0 # The amount of power with which the bomb pushes
export var damage = 6.0 # The damage that the bomb will cause
export var time_left = 10.0 # The time left for the bomb before auto-explode
var exploded = false # Did we already explode?
var camera_shake_distance = 600 # Radius around the bomb where the shake still applies (in pixels)
var anim_player # The bomb's animation player
var player # The player
var force = Vector2(0,0) # The force of movement
var source = "magic" # The shooter of the bomb
var speed = 0.0 # Fixed a crash
var remove_after = 0 # Seconds untill the animation finishes
var gun_sounds # All the sounds of the different guns are in the same sample library
var light # The light node

func _ready():
	anim_player = get_node("AnimationPlayer") # Save the animation player as a variable for easier use
	player = get_node("../player") # Save the player node for easier use
	gun_sounds = get_node("GunSounds") # We need the sounds of the guns to get the bomb sound
	light = get_node("BombLight") # The light node
	set_fixed_process(true) # We use _fixed_process to count the time left untill the explosion, and to actually explode

func _fixed_process(delta):
	remove_after -= delta # Decrease by the time elapsed
	if(time_left <= 0 && !exploded): # Enough time had passed
		var bodies = get_node("Area2D").get_overlapping_bodies()
		for body in bodies: # Loop through all the coliding bodies
			var diminish = max(200/(get_pos() - body.get_pos()).length() - 1, 0) # Diminish the amount of damage and push based on the distance
			if(body.has_method("damage")): # And damage them, if possible
				body.damage("bomb",damage * diminish)
			if(body extends RigidBody2D && !body extends get_script()): # When it is a rigidbody, but not a bomb
				var direction = (body.get_pos() - get_pos()).normalized() # The direction in which we push
				body.apply_impulse(get_pos(), direction * diminish * push) # Move it awaty from the bomb
		set_layer_mask(0) # Make so the bomb collides with nothing
		set_collision_mask(0) # Make so nothing collides with the bomb
		gun_sounds.play("bomb")
		anim_player.play("explode") # Play the explode animation
		remove_after = anim_player.get_current_animation_length()
		player.camera_shake(12, get_pos(), camera_shake_distance, 3) # Shake the player's camera
		exploded = true # Prevent damage on every frame
	if(exploded && remove_after <= 0.0):
		queue_free() # Delete the bomb after the animation is finished

func damage(from, amount):
	time_left = 0 # Explode when damaged
