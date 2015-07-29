# casign.gd -> RigidBody2D
extends RigidBody2D

var force = Vector2(0,0) # The force of movement
var source = "magic" # The source of the casign
var die_on_timeout = true # Should the CASIGN be removed when there is no time left?
export var take_player_speed = 0.5 # Should the casign inherit the player's speed
export var speed = 60.0 # The speed of the casign (around 60 makes for a normal spped)
export var time_left = 1.0 # The time left for the casign to live
var animationPlayer # The animation player!

func _ready():
	set_fixed_process(true) # We use _fixed_process to move and die
	
	animationPlayer = get_node("AnimationPlayer") # The animation player!
#	animationPlayer.connect("finished", self, "anim_player_finished") # To remove the casign from the scene

func _fixed_process(delta):
	time_left -= delta # Decrease the time left for the casign to live
#	print("casquete: "+ str(time_left))
	if((time_left <= 0) and (die_on_timeout)):
		animationPlayer.play("die") # Die when no time is left
		die_on_timeout = false

	set_linear_velocity(get_linear_velocity() + force) # Set its velocity
	force = force.linear_interpolate(Vector2(0, 0), delta*4)
	for body in get_colliding_bodies(): # For each boddy we collide with
		if(body.has_method("damage")):
			if(die_on_timeout):
				animationPlayer.play("die") # And remove the casign
				die_on_timeout = false
	
func anim_player_finished():
	queue_free()