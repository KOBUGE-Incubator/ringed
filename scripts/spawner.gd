
extends StaticBody2D

export(PackedScene) var object_scene
export var cooldown = 5.0
var time_left
var raycast

func _ready():
	raycast = get_node("ray")
	raycast.add_exception(self)
	
	time_left = cooldown
	
	set_fixed_process(true)

func _fixed_process(delta):
	time_left -= delta
	print(raycast.is_colliding(), raycast.get_collider(), raycast.get_cast_to())
	if(time_left < 0 && !raycast.is_colliding()):
		var node = object_scene.instance()
		
		node.set_pos(get_pos())
		node.set_rot(get_rot())
		get_node("../../").add_child(node)
		
		time_left = cooldown


