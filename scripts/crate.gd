# crate.gd -> RigidBody2D
extends RigidBody2D

export var max_health = 50.0 # The start amount of health
export var step = 10.0 # The step after which we make one particle
var camera_shake_distance = 300 # Radius around the bomb where the shake still applies (in pixels)
var health = 0.0 # The current amount of health
var anim_player # Then animation player node
var occluder # The light occluder of the box

func _ready():
	anim_player = get_node("AnimationPlayer") # Get the node
	occluder = get_node("Sprite/LightOccluder2D") # Get the node
	anim_player.connect("finished", self, "finish") # We connect the animation player's finished signal to the finish function
	health = max_health # Reset health

func damage(from, amount): # Damage the creature from a given source
	health =  max(health - amount , -0.1) # Make sure not to get under 0
	if(health < 0.0):
		set_layer_mask(0) # Disable Collisions
		set_collision_mask(0) # Disable Collisions
		anim_player.play("explode") # Explode
		get_node("../player").camera_shake(6, get_pos(), camera_shake_distance, 3) # Shake the player's camera
	else:
		var c = step
		for i in range(0,floor(max_health/step)):
			c += step
			if(health < c && health + amount >= c): # We passed the step
				anim_player.stop()
				anim_player.play("particle")
				break
	return true # Say that the box was damaged

func finish():
	if(health < 0.0): # Make sure that we should really remove it
		queue_free()
