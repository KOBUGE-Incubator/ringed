# gun.gd -> Node2D
extends Node2D

export var shot_cooldown = 0.2 # Time between two auto-shots
export var bullet_scn_path = "res://scenes/bullet.xml" # The bullet scene
export var bullet_casign_scn_path = "res://scenes/casign.xml" # The bullet casign scene
export var hasShotLight = false # If the gun produces a shot light
export var recoil_bullet_variation = 0.0 # The amount variation in degrees for the bullet direction + and -, caused by the recoil
var bullet_offset = Vector2(0, 0) # The offset of the bullet (taken from the "Bullet" node)
var bullet_scn # The bullet scene
var time_for_next_shot = 0.0 # How much time is left till the next shot?
var bullet_holder # The node that will contain the nodes
var bullet_casign_offset = Vector2(0, 0) # The offset of the bullet (taken from the "Casigns" node)
export var casigns = false # To know if we need to emmit casigns
export var casign_spin = 0.0 # Spin velocity used in the casigns
export var casign_direction_variation = 0.0 # The amount variation in degrees for the casign direction + and -
var bullet_casign_holder # The node that will contain the shell casigns
var bullet_casign_scn # The bullet casign scene
var shotLight # The node of the shot's light
var shot_occluder # The occluder that the shot light projects
var player # The player
var gun_animations # The AnimationPlayer node of the gun


func _ready():
	bullet_offset = get_node("Bullet").get_pos() + get_parent().get_pos() + get_pos() # We need the position of the tip of the rifle
	shotLight = get_node("ShotLight")
	shot_occluder = get_node("ShotOccluder")
	gun_animations = get_node("GunAnimations")
	player = get_parent().get_parent() # The player
	bullet_holder = player.get_parent() # Get the parent (world) of the player
	bullet_scn = load(bullet_scn_path)
	if(casigns):
		bullet_casign_offset = get_node("Casigns").get_pos() + get_parent().get_pos() + get_pos() # We need the position of the right side of the rifle
		bullet_casign_scn = load(bullet_casign_scn_path)
		bullet_casign_holder = player.get_parent() # Get the parent (world) of the player
	set_fixed_process(true)
func _fixed_process(delta):
	time_for_next_shot -= delta # We decrease the time till the next shot by the time elapsed
	if(time_for_next_shot <= 0 and hasShotLight == true): # We turn off the shot's light 
		shotLight.set_enabled(false)
		shot_occluder.set_enabled(false)
func shot():
	if (hasShotLight == true):
		shotLight.set_enabled(false) # We disable the shot's light
		shot_occluder.set_enabled(false) # Whe disable the shot's occluder
	if(time_for_next_shot <= 0):
		var rotation = player.get_rot() + rand_range(-0.01,0.01) # The rotation of the player
		var bullet = bullet_scn.instance() # We instance the bullet scene
		bullet_holder.add_child(bullet) # Then we add it to the scene
		bullet.set_pos(player.get_pos() + bullet_offset.rotated(rotation)) # We move the bullet to the right position
		bullet.set_rot(rotation) # Also we rotate it
		if (hasShotLight == true):
			shotLight.set_enabled(true) # We enable the shot's light
			shot_occluder.set_enabled(true) # Whe enable the shot's occluder
		var variation = rand_range(-recoil_bullet_variation, recoil_bullet_variation)
		bullet.force = Vector2(0,bullet.speed).rotated(rotation + deg2rad(180+variation)) # We set its course
		do_recoil()
		if(bullet.take_player_speed):
			bullet.set_linear_velocity(player.get_linear_velocity() * bullet.take_player_speed)
		bullet.source = "player" # The player shoots the bullet
		time_for_next_shot = shot_cooldown # To prevent ultra-fast fire

func do_recoil():
	if(gun_animations):
		gun_animations.play("recoil")
		if(casigns):
			var rotation = player.get_rot() + rand_range(-0.01,0.01) # The rotation of the player
			var casign = bullet_casign_scn.instance() # We instance the bullet casign scene
			bullet_casign_holder.add_child(casign) # Then we add it to the scene
			casign.set_pos(player.get_pos() + bullet_casign_offset.rotated(rotation)) # We move the bullet to the right position
			casign.set_rot(rotation) # Also we rotate it
			var variation = rand_range(-casign_direction_variation, casign_direction_variation)
			casign.speed = 40
			casign.force = Vector2(-casign.speed,0).rotated(rotation + deg2rad(180+variation)) # We set its course
			casign.set_angular_velocity(casign_spin) 
			casign.source = "player" # The player shoots the bullet