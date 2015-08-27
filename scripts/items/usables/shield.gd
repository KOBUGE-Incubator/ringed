extends Area2D

var collider 
var source
export var bounce = 2.5
#Sounds
var sounds
export var sound_bounce = ""

func _ready():
	source = get_parent().get_parent()
	sounds = get_node("SamplePlayer2D")
	connect("body_enter",self,"shield_collision")

func shield_collision(body):
	if((body != source)&&(body.get_type() == "RigidBody2D")&&(is_visible())):
		body.set_linear_velocity(body.get_linear_velocity()*(-bounce))
		sounds.play(sound_bounce)

func repeal_overlaping_bodies():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		shield_collision(body)

func show():
	if(is_hidden()):
		.show()
		repeal_overlaping_bodies()
		return
	.show()