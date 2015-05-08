extends "moveable_object.gd"

export var max_health = 5
export var cooldown = 0.2
var healthbar
var healthbarHolder
var health
var healthbar_region
var cooldown_left = 0.0

func _ready():
	set_process(true)
	add_to_group("enemies")
	healthbarHolder = get_node("HealthHolder")
	healthbar = get_node("HealthHolder/HealthBar")
	health = max_health
	healthbar_region = healthbar.get_region_rect()

func logic(delta):
	cooldown_left -= delta
	
	target_angle = get_pos().angle_to_point( get_parent().get_node("player").get_pos() ) + deg2rad(0)
	force = Vector2(0,-1).rotated(target_angle)
	
	for body in get_colliding_bodies():
		if(body.has_method("damage") && cooldown_left <= 0):
			if(body.damage("spider")):
				cooldown_left = cooldown
				heal()

func _process(delta):
	healthbarHolder.set_rot(-get_rot())

func heal():
	health = min(health + 1, max_health)
	var new_region = healthbar_region
	new_region.size.x *= health*1.0/max_health
	healthbar.set_region_rect(new_region)
	if(health >= max_health):
		healthbarHolder.hide()

func damage(from):
	if(from == "player"):
		health -= 1
		var new_region = healthbar_region
		new_region.size.x *= health*1.0/max_health
		healthbar.set_region_rect(new_region)
		if(health < max_health):
			healthbarHolder.show()
		if(health <= 0):
			queue_free()
		return true;
