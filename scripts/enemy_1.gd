extends "living_object.gd"


export var cooldown = 0.2
var cooldown_left = 0.0

func _ready():
	add_to_group("enemies")

func logic(delta):
	cooldown_left -= delta
	
	target_angle = get_pos().angle_to_point( get_parent().get_node("player").get_pos() ) + deg2rad(0)
	force = Vector2(0,-1).rotated(target_angle)
	
	for body in get_colliding_bodies():
		if(body.has_method("damage") && cooldown_left <= 0):
			if(body.damage("spider",1)):
				cooldown_left = cooldown
				heal(0.5)

func can_get_damage(from):
	if(from != "spider"):
		return true
	return false
