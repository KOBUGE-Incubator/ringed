
extends StaticBody2D

export var max_offset = 5.0 # The max offset from the original position of a leaf
export var fade_radius = 400.0 # The distance from which the leaves start to fade out
export var min_opacity = 0.1 # The minimum opacity of the leaves
var leaves # The node with the leaves
var player # The player node

func _ready():
	#Get nodes
	leaves = get_node("Leaves")
	player = get_node("../../player")
	
	# Randomize
	for i in range(leaves.get_child_count()):
		var leaf = leaves.get_child(i)
		leaf.set_rot(rand_range(0, PI*2))
		var offset = Vector2(rand_range(-max_offset, max_offset),rand_range(-max_offset, max_offset))
		leaf.set_offset(offset)
	
	set_process(true)

func _process(delta):
	var distance = get_pos().distance_squared_to(player.get_pos()) # The distance to the player
	leaves.set_opacity(min(distance/fade_radius/fade_radius + min_opacity, 1)) # Always between 0..1
