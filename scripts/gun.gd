# gun.gd -> Node2D
extends Node2D

export var shot_cooldown = 0.2 # Time between two auto-shots
export var bullet_scn_path = "res://scenes/bullet.xml" # The bullet scene
export var bullet_setting = ""
export var bullet_casing_scn_path = "res://scenes/casing.xml" # The bullet casing scene
export var hasShotLight = false # If the gun produces a shot light
export var recoil_bullet_variation = 0.0 # The amount variation in degrees for the bullet direction + and -, caused by the recoil
var bullet_offset = Vector2(0, 0) # The offset of the bullet (taken from the "Bullet" node)
var bullet_scn # The bullet scene
var time_for_next_shot = 0.0 # How much time is left till the next shot?
var bullet_holder # The node that will contain the nodes
var bullet_casing_offset = Vector2(0, 0) # The offset of the bullet (taken from the "Casigns" node)
export var casings = false # To know if we need to emmit casings
export var casing_spin = 0.0 # Spin velocity used in the casings
export var casing_direction_variation = 0.0 # The amount variation in degrees for the casing direction + and -
var bullet_casing_holder # The node that will contain the shell casings
var bullet_casing_scn # The bullet casing scene
var shotLight # The node of the shot's light
var shot_occluder # The occluder that the shot light projects
var player # The player
var gun_animations # The AnimationPlayer node of the gun
export var ammo = 600 
export var c_ammo = 600 # -1 for infinite ammo


func _ready():
	bullet_offset = get_node("Bullet").get_pos() + get_parent().get_pos() + get_pos() # We need the position of the tip of the rifle
	shotLight = get_node("ShotLight")
	shot_occluder = get_node("ShotOccluder")
	gun_animations = get_node("GunAnimations")
	player = get_parent().get_parent() # The player
	bullet_holder = player.get_parent() # Get the parent (world) of the player
	if(bullet_setting != ""):
		var setting = get_node("/root/global").get(bullet_setting)
		bullet_scn = load(str(bullet_scn_path.basename(), "_", setting, ".", bullet_scn_path.extension()))
	else:
		bullet_scn = load(bullet_scn_path)
	if(casings):
		bullet_casing_offset = get_node("Casigns").get_pos() + get_parent().get_pos() + get_pos() # We need the position of the right side of the rifle
		bullet_casing_scn = load(bullet_casing_scn_path)
		bullet_casing_holder = player.get_parent() # Get the parent (world) of the player
	set_fixed_process(true)
func _fixed_process(delta):
	time_for_next_shot -= delta # We decrease the time till the next shot by the time elapsed
	if(time_for_next_shot <= 0 and hasShotLight == true): # We turn off the shot's light 
		shotLight.set_enabled(false)
		shot_occluder.set_enabled(false)
func shot():
	if((c_ammo != 0) or (c_ammo == -1)): # We don't have more ammo
		if (hasShotLight == true):
			shotLight.set_enabled(false) # We disable the shot's light
			shot_occluder.set_enabled(false) # Whe disable the shot's occluder
		if(time_for_next_shot <= 0):
			var rotation = player.get_rot() + rand_range(-0.01,0.01) # The rotation of the player
			var bullet = bullet_scn.instance() # We instance the bullet scene
			if(not bullet extends RigidBody2D):
				var holder = bullet
				for child in holder.get_children():
					if(child extends RigidBody2D):
						holder.remove_child(child)
						bullet = child
				holder.queue_free()
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
			c_ammo -= 1

func do_recoil():
	if(gun_animations):
		gun_animations.play("recoil")
		if(casings):
			var rotation = player.get_rot() + rand_range(-0.01,0.01) # The rotation of the player
			var casing = bullet_casing_scn.instance() # We instance the bullet casing scene
			bullet_casing_holder.add_child(casing) # Then we add it to the scene
			casing.set_pos(player.get_pos() + bullet_casing_offset.rotated(rotation)) # We move the bullet to the right position
			casing.set_rot(rotation) # Also we rotate it
			var variation = rand_range(-casing_direction_variation, casing_direction_variation)
			casing.speed = 40
			casing.force = Vector2(-casing.speed,0).rotated(rotation + deg2rad(180+variation)) # We set its course
			casing.set_angular_velocity(casing_spin) 
			casing.source = "player" # The player shoots the bullet