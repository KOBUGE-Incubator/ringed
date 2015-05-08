extends Node2D

var time = 0
var enemy_scn = load("res://scenes/enemy_1.xml")
var background
var side = 0
var y = 0
var x = 0
var offset

func _ready():
	background = get_node("CanvasLayer/background")
	randomize()
	set_fixed_process(true)
	set_process(true)
	
func _process(delta):
	offset = -get_viewport().get_canvas_transform().o 
	var o = offset/Vector2(1024,768)
	background.get_material().set_shader_param("Offset",Vector3(o.x,o.y,0))
	background.set_region_rect(get_viewport_rect())

func _fixed_process(delta):
	time += delta
	if time > 0.7:
		time = 0
		side = randi() % 4
		if side == 0:
			x = randi() % int(get_viewport_rect().size.x)
			y = - 100
		elif side == 1:
			x = int(get_viewport_rect().size.x) + 100
			y = randi() % int(get_viewport_rect().size.y)
		elif side == 2:
			x = randi() % int(get_viewport_rect().size.x)
			y = int(get_viewport_rect().size.y) + 100
		elif side == 3:
			x = -100
			y = randi() % int(get_viewport_rect().size.y)
		
		var enemy = enemy_scn.instance()
		enemy.set_pos(Vector2(x,y) + offset)
		add_child(enemy)