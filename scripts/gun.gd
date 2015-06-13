# gun.gd -> Node2D
extends Node2D

export var shot_cooldown = 0.2 # Time between two auto-shots
export var bullet_scn_path = "res://scenes/bullet.xml" # The bullet scene
export var hasShotLight = false # If the gun produces a shot light
var bullet_offset = Vector2(0, 0) # The offset of the bullet (taken from the "Bullet" node)
var bullet_scn # The bullet scene
var time_for_next_shot = 0.0 # How much time is left till the next shot?
var bullet_holder # The node that will contain the nodes
var shotLight # The node of the shot's light
var player # The player

func _ready():
	bullet_offset = get_node("Bullet").get_pos() + get_parent().get_pos() + get_pos() # We need the position of the tip of the rifle
	shotLight = get_node("ShotLight")
	player = get_parent().get_parent() # The player
	bullet_holder = player.get_parent() # Get the parent (world) of the player
	bullet_scn = load(bullet_scn_path)
	
	set_fixed_process(true)
func _fixed_process(delta):
	time_for_next_shot -= delta # We decrease the time till the next shot by the time elapsed
	if(time_for_next_shot == 0 and hasShotLight == true): # We turn off the shot's light 
		shotLight.set_enabled(false)
func shot():
	if (hasShotLight == true):
		shotLight.set_enabled(false) # We disable the shot's light
	if(time_for_next_shot <= 0):
		var rotation = player.get_rot() + rand_range(-0.01,0.01) # The rotation of the player
		var bullet = bullet_scn.instance() # We instance the bullet scene
		bullet_holder.add_child(bullet) # Then we add it to the scene
		bullet.set_pos(player.get_pos() + bullet_offset.rotated(rotation)) # We move the bullet to the right position
		bullet.set_rot(rotation) # Also we rotate it
		if (hasShotLight == true):
			shotLight.set_enabled(true) # We enable the shot's light
		bullet.force = Vector2(0,bullet.speed).rotated(rotation + deg2rad(180)) + player.get_linear_velocity() # We set its course
		bullet.source = "player" # The player shoots the bullet
		time_for_next_shot = shot_cooldown # To prevent ultra-fast fire


