extends RigidBody2D

var angle = 0.0
var source = "magic"
export var speed = 60.0

func _ready():
	set_fixed_process(true)
	add_to_group("bullets")
	
func _fixed_process(delta):
	set_linear_velocity(Vector2(0,speed).rotated(angle))
	
	for body in get_colliding_bodies():
		if(body.has_method("damage")):
			if(body.damage(source)):
				queue_free()