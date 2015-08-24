
extends Node2D

var particles
var animations
var is_unfocus = null

func _ready():
	particles = get_node("Parallax/Particles")
	animations = get_node("AnimationPlayer")

func hide_particles(flag):
	if(flag):
		particles.hide()
	else:
		particles.show()

func make_unfocus():
	animations.connect("finished", self, "is_unfocus")
	if((is_unfocus == null) or (is_unfocus == false)):
		animations.play("unfocus")

func make_focus():
	animations.connect("finished", self, "is_focus")
	if(is_unfocus == true):
		animations.play("focus")

func is_unfocus():
	is_unfocus = true
	animations.disconnect("finished",self, "is_unfocus")

func is_focus():
	is_unfocus = false
	animations.disconnect("finished",self, "is_focus")



