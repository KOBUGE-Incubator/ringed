# bomb.gd -> RigidBody2D
extends RigidBody2D

export var time_till_explode = 2.0 # Seconds untill the explosion happens
export var damage = 1.0 # The amount of damage we deal
var exploded = false # Did we already explode?

func _ready():
	get_node("AnimationPlayer").connect("finished", self, "finish") # We connect the animation player's finished signal to the finish function
	set_fixed_process(true) # We use _fixed_process to count the time left untill the explosion, and to actually explode

func _fixed_process(delta):
	time_till_explode -= delta # Decrease the time left by the time elapsed
	
	if(time_till_explode <= 0 && !exploded): # Enough time had passed
		var bodies = get_node("Area2D").get_overlapping_bodies()
		for body in bodies: # Loop through all the coliding bodies
			if(body.has_method("damage")): # And damage them, if possible
				var diminish = max(200/(get_pos() - body.get_pos()).length() - 1, 0) # Diminish the amount of damage based on the distance
				body.damage("bomb",damage * diminish)
		exploded = true # Prevent damage on every frame
		set_layer_mask(0) # Make so the bomb collides with nothing
		set_collision_mask(0) # Make so nothing collides with the bomb
		get_node("AnimationPlayer").play("explode") # Play the explode animation

func finish(): # Called when the animationPlayer finishes playing an animation
	if(exploded): # Make sure the right animation finished
		queue_free() # Delete

func damage(from, amount):
	time_till_explode = 0 # Explode when damaged
