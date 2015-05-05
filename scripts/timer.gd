extends Timer

func _ready():
	set_fixed_process(true)
	start()
	
func _fixed_process(delta):
	if get_time_left() < 1:
		print("A")