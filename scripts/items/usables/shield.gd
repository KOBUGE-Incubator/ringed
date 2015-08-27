extends Node2D

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
		print(body.get_linear_velocity())


