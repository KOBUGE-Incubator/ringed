extends RigidBody2D

var angle = 0.0
var source = "magic"
export var speed = 60.0
export var time_left = 10.0
export var damage = 1.0

func _ready():
	set_fixed_process(true)
	add_to_group("bullets")
	
func _fixed_process(delta):
	time_left -= delta
	
	set_linear_velocity(Vector2(0,speed).rotated(angle))
	
	if(time_left < 0):
		queue_free()
	
	for body in get_colliding_bodies():
		if(body.has_method("damage")):
			body.damage(source,damage)
		queue_free()