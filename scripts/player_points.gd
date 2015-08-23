
extends Label

var player

func _ready():
	player = get_node("../../player")
	set_process(true)

func _process(delta):
	self.set_text(str(player.points))



