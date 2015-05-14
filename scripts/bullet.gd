# bullet.gd -> RigidBody2D
extends RigidBody2D

var force = Vector2(0,0) # The force of movement
var source = "magic" # The shooter of the bullet
export var speed = 60.0 # The speed of the bullet (around 700 makes for a normal spped)
export var time_left = 10.0 # The time left for the bullet to live
export var damage = 1.0 # The damage that the bullet will cause

func _ready():
	set_fixed_process(true) # We use _fixed_process to move and die
	
	add_to_group("bullets") # Mark it as a bullet

func _fixed_process(delta):
	time_left -= delta # Decrease the time left for the bullet to live
	
	set_linear_velocity(force) # Set its velocity
	
	if(time_left < 0):
		queue_free() # Die when no time is left
	
	for body in get_colliding_bodies(): # For each boddy we collide with
		if(body.has_method("damage")):
			body.damage(source,damage) # Damage it if possible
		queue_free() # And remove the bullet
