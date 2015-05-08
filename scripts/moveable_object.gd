extends RigidBody2D

export var speed = 5.0
export var rotation_speed = 1000.0
var force = Vector2(0, 0)
var target_angle = 0.0

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	Input.set_mouse_mode(1)

func _fixed_process(delta):
	logic(delta) # Think first
	
	if(force.length_squared() > 1):
		force = force.normalized() # Prevent too fast movements
	set_linear_velocity(get_linear_velocity() + force * speed * delta) # Move
	
	var t_dir = Vector2(0,1).rotated(target_angle) # Rotate
	var c_dir = Vector2(0,1).rotated(get_rot())
	c_dir = c_dir.linear_interpolate(t_dir, min(rotation_speed * delta, 1))
	set_rot(atan2(c_dir.x,c_dir.y))

func logic(delta):
	pass

