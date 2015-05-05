extends Node2D

var time = 0
var enemy_scn = load("res://scenes/enemy_1.xml")
var side = 0
var y = 0
var x = 0

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	time += delta
	if time > 0.5:
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
		enemy.set_pos(Vector2(x,y))
		add_child(enemy)