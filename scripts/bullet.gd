extends KinematicBody2D

var angle = 0.0

func _ready():
	set_fixed_process(true)
	add_to_group("bullets")
	
func _fixed_process(delta):
	move(Vector2(0,20).rotated(angle))