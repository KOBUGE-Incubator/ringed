extends "moveable_object.gd"

func _ready():
	set_fixed_process(true)
	add_to_group("enemies")
	
func logic():
	target_angle = get_pos().angle_to_point( get_parent().get_node("player").get_pos() ) + deg2rad(0)
	force = Vector2(0,-1).rotated(target_angle)

func damage(from):
	if(from == "player"):
		queue_free()
		return true;
