extends KinematicBody2D

var angle
var rotation
var collider

func _ready():
	set_fixed_process(true)
	add_to_group("enemies")
	
func _fixed_process(delta):
	angle = get_pos().angle_to_point( get_parent().get_node("player").get_pos() ) + deg2rad(180)
	rotation = get_pos().angle_to_point( get_parent().get_node("player").get_pos() ) + deg2rad(0)
	move(Vector2(0,4).rotated(angle))
	set_rot(rotation)
	
	if is_colliding():
		if get_collider().is_in_group("bullets"):
			queue_free()
			get_collider().queue_free()
