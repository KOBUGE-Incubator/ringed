extends "moveable_object.gd"

export var heal_cooldown = 0.2
export var max_health = 6
export var hide_when_full = false
var healthbar
var healthbarHolder
var health
var healthbar_region
var time_for_next_heal = 0.0

func _ready():
	healthbarHolder = get_node("HealthHolder")
	healthbar = get_node("HealthHolder/HealthBar")
	
	health = max_health
	healthbar_region = healthbar.get_region_rect()
	if(hide_when_full):
		healthbarHolder.hide()
	else:
		healthbarHolder.show()
	
	
	set_process(true)
	set_fixed_process(true)
	

func _process(delta):
	healthbarHolder.set_rot(-get_rot())

func _fixed_process(delta):
	time_for_next_heal -= delta
	
	if(time_for_next_heal <= 0):
		time_for_next_heal = heal_cooldown
		heal(1)

func update_health():
	var new_region = healthbar_region
	new_region.size.x *= health*1.0/max_health
	healthbar.set_region_rect(new_region)
	if(health <= 0):
		die()
	if(hide_when_full && health >= max_health):
		healthbarHolder.hide()
	else:
		healthbarHolder.show()

func heal(amount):
	health = min(health + amount, max_health)
	update_health()
	
func can_get_damage(from):
	return true

func damage(from, amount):
	if(can_get_damage(from)):
		health -= amount
		time_for_next_heal = heal_cooldown
		update_health()
		return true
	return false

func die():
	queue_free()

