# bomb.gd -> RigidBody2D
extends RigidBody2D

export var time_till_explode = 2.0 # Seconds untill the explosion happens
export var damage = 1.0 # The amount of damage we deal

func _ready():
	set_fixed_process(true) # We use _fixed_process to count the time left untill the explosion, and to actually explode

func _fixed_process(delta):
	time_till_explode -= delta # Decrease the time left by the time elapsed
	
	if(time_till_explode <= 0): # Enough time had passed
		var bodies = get_node("Area2D").get_overlapping_bodies()
		for body in bodies: # Loop through all the coliding bodies
			if(body.has_method("damage")): # And damage them, if possible
				body.damage("bomb",damage)
		queue_free()

func damage(from, amount):
	time_till_explode = 0 # Explode when damaged
