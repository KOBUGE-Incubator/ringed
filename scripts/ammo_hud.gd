
extends Control

var player
var c_weapon
export var preview_margin = 5
export var preview_rotation = 1.0

func _ready():
	player = get_node("../../player")
	c_weapon = player.current_gun_node
	set_process(true)

func _process(d):
	c_weapon = player.current_gun_node
	set_ammo_text()
	set_weapon_preview()
	check_reloading()

func set_ammo_text():
	var ammo_text
	if(c_weapon.c_ammo < 0):
		ammo_text = "enjoy!"
	else:
		ammo_text = str(c_weapon.c_ammo_clip_size)+"/"+str(c_weapon.c_ammo)
	self.get_node("Label").set_text(ammo_text)

func set_weapon_preview ():
	var new_sprite = c_weapon.get_node("Sprite").duplicate()
	var c_sprite = get_node("Sprite")
	if(c_sprite):
		self.remove_child(c_sprite)
		c_sprite.free()
	#Make the weapon preview in the spot
	var spot_size = self.get_size()
	new_sprite.show() #Always show the sprite
	new_sprite.set_rot(preview_rotation) #Clean rotation
	#Scale the sprite to fill the spot with a margin
	var weapon_sprite_size = new_sprite.get_texture().get_size()
	var scale
	if(weapon_sprite_size.x > weapon_sprite_size.y):
		scale = get_scale_factor(weapon_sprite_size.x,(spot_size.x - preview_margin))
	else:
		scale = get_scale_factor(weapon_sprite_size.y,(spot_size.x - preview_margin))
	new_sprite.set_scale(Vector2(scale,scale))
	new_sprite.set_pos(spot_size/2)
	new_sprite.set_pos(Vector2(new_sprite.get_pos().x,new_sprite.get_pos().y-(self.get_node("Label").get_size().height)))
	self.add_child(new_sprite)
	self.move_child(new_sprite,0)

func get_scale_factor(c_size,target_size):
	var delta_size = c_size - target_size
	var delta_scale_factor = delta_size/c_size
	return (1-delta_scale_factor)

func check_reloading():
	if(c_weapon.c_ammo >= 0):
		if(c_weapon.is_reloading):
			self.set_opacity(0.3)
		else:
			self.set_opacity(1)
