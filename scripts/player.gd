extends "moveable_object.gd"

export var shot_cooldown = 0.2
export var heal_cooldown = 0.2
export var max_health = 6
var bullet_scn = load("res://scenes/bullet.xml")
var mouse_pos = Vector2(0, 0)
var relative_mouse_pos = Vector2(0, 0)
var bullet_offset = Vector2(0, 0)
var time_for_next_shot = 0.0
var healthbar
var healthbarHolder
var health
var healthbar_region
var time_for_next_heal = 0.0

func _ready():
	bullet_offset = get_node("Bullet").get_pos()
	healthbarHolder = get_node("HealthHolder")
	healthbar = get_node("HealthHolder/HealthBar")
	
	health = max_health
	healthbar_region = healthbar.get_region_rect()
	
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	Input.set_mouse_mode(1)

func _process(delta):
	var offset = -get_viewport().get_canvas_transform().o
	relative_mouse_pos = mouse_pos + offset
	healthbarHolder.set_rot(-get_rot())

func logic(delta):
	time_for_next_shot -= delta
	time_for_next_heal -= delta
	force = Vector2(0,0)
	if Input.is_action_pressed("D"):
		force += Vector2(1,0)
	if Input.is_action_pressed("A"):
		force += Vector2(-1,0)
	if Input.is_action_pressed("S"):
		force += Vector2(0,1)
	if Input.is_action_pressed("W"):
		force += Vector2(0,-1)
	if(time_for_next_heal <= 0):
		time_for_next_heal = heal_cooldown
		heal()
	if(Input.is_action_pressed("Shot") && time_for_next_shot <= 0):
		var bullet = bullet_scn.instance()
		get_parent().add_child(bullet)
		bullet.set_pos(get_pos() + bullet_offset.rotated(get_rot()))
		bullet.angle = get_rot() + deg2rad(180)
		bullet.source = "player"
		time_for_next_shot = shot_cooldown
	target_angle = get_pos().angle_to_point( relative_mouse_pos ) + deg2rad(0)
	get_node("../cursor").set_pos(relative_mouse_pos)

func heal():
	health = min(health + 1, max_health)
	var new_region = healthbar_region
	new_region.size.x *= health*1.0/max_health
	healthbar.set_region_rect(new_region)
	
func damage(from):
	if(from != "player"):
		health -= 1
		var new_region = healthbar_region
		new_region.size.x *= health*1.0/max_health
		healthbar.set_region_rect(new_region)
		if(health <= 0):
			get_tree().set_pause(true)
		return true;

func _input(event):
	if event.type == 2:
		mouse_pos = event.pos
