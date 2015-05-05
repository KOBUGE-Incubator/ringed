extends KinematicBody2D

var speed = 5
var bullet_scn = load("res://scenes/bullet.xml")

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	Input.set_mouse_mode(1)

func _fixed_process(delta):
	if Input.is_action_pressed("D"):
		move(Vector2(speed,0))
	if Input.is_action_pressed("A"):
		move(Vector2(-speed,0))
	if Input.is_action_pressed("S"):
		move(Vector2(0,speed))
	if Input.is_action_pressed("W"):
		move(Vector2(0,-speed))

func _input(event):
	if event.type == 2:
		get_node("../cursor").set_pos(event.pos)
		set_rot( get_pos().angle_to_point( event.pos ) + deg2rad(0) )
	
	if event.type == 3:
		var bullet = bullet_scn.instance()
		get_owner().add_child(bullet)
		add_collision_exception_with(bullet)
		bullet.set_pos(get_pos())
		bullet.angle = get_pos().angle_to_point( event.pos ) + deg2rad(180)
