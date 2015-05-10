# moveable_object.gd -> RigidBody2D
extends RigidBody2D

export var speed = 700.0 # The speed with which the object moves
export var rotation_speed = 1000.0 # The speed with which it rotates (100.0 is usually enough, but still...)
var force = Vector2(0, 0) # The force of movement
var target_angle = 0.0 # The angle we want to look at

func _ready():
	set_fixed_process(true) # We use _fixed_process to move

func _fixed_process(delta):
	logic(delta) # Use the logic function to change the force and target angle
	
	if(force.length_squared() > 1): # When we try to move with a force greater than one (length_squared is used because it is faster) 
		force = force.normalized() # Normalize the force vector, so its length equals one
	
	set_linear_velocity(get_linear_velocity() + force * speed * delta) # Move The object
	
	# Interpolate the angle
	var t_dir = Vector2(0,1).rotated(target_angle) # We make a unit vector (one that has a length of one) poiting in the final direction
	var c_dir = Vector2(0,1).rotated(get_rot()) # Then we make another unit vector in the wanted direction
	c_dir = c_dir.linear_interpolate(t_dir, min(rotation_speed * delta, 1)) # We interpolate between them
	set_rot(atan2(c_dir.x,c_dir.y)) # Then we use the angle of the interpolated vector as the rotation

func logic(delta):
	pass # Do absolutely nothing

