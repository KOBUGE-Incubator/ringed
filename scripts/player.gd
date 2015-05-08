extends "moveable_object.gd"

var bullet_scn = load("res://scenes/bullet.xml")
var mouse_pos = Vector2(0, 0)
var bullet_offset = Vector2(0, 0)

func _ready():
	bullet_offset = get_node("Bullet").get_pos()
	
	set_fixed_process(true)
	set_process_input(true)
	Input.set_mouse_mode(1)

func logic():
	force = Vector2(0,0)
	if Input.is_action_pressed("D"):
		force += Vector2(1,0)
	if Input.is_action_pressed("A"):
		force += Vector2(-1,0)
	if Input.is_action_pressed("S"):
		force += Vector2(0,1)
	if Input.is_action_pressed("W"):
		force += Vector2(0,-1)
	target_angle = get_pos().angle_to_point( mouse_pos ) + deg2rad(0)

func _input(event):
	if event.type == 2:
		get_node("../cursor").set_pos(event.pos)
		mouse_pos = event.pos
	
	if event.type == 3:
		var bullet = bullet_scn.instance()
		get_parent().add_child(bullet)
		bullet.set_pos(get_pos() + bullet_offset.rotated(get_rot()))
		bullet.angle = get_rot() + deg2rad(180)
		bullet.source = "player"
