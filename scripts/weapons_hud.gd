
extends Control

var player
var weapons
var spot
export var preview_margin = 15

func _ready():
	player = get_node("../../player")
	weapons = player.get_node("Guns").get_children()
	spot = get_node("Spot")
	spot.hide()
	make_spots()

func make_spots():
	var index = 0
	for weapon in weapons:
		make_weapon_spot(weapon,index)
		index += 1
	
func make_weapon_spot(weapon,index):
	#Make the visual spot
	var x_position = spot.get_texture().get_width()*index
	var c_weapon_spot = spot.duplicate()
	c_weapon_spot.set_pos(Vector2(x_position,c_weapon_spot.get_pos().y))
	c_weapon_spot.get_node("Number").set_text(str(index+1)) #set the spot number
	c_weapon_spot.show()
	#Make the weapon preview in the spot
	var spot_size = spot.get_texture().get_size()
	var weapon_sprite = weapon.get_node("Sprite").duplicate()
	weapon_sprite.show() #Always show the sprite
	weapon_sprite.set_rot(0) #Clean rotation
	#Scale the sprite to fill the spot with a margin
	var weapon_sprite_size = weapon_sprite.get_texture().get_size()
	var scale
	if(weapon_sprite_size.x > weapon_sprite_size.y):
		scale = get_scale_factor(weapon_sprite_size.x,(spot_size.x - preview_margin))
	else:
		scale = get_scale_factor(weapon_sprite_size.y,(spot_size.x - preview_margin))
	weapon_sprite.set_scale(Vector2(scale,scale))
	weapon_sprite.set_pos(spot_size/2)
	#Add the spot and the preview sprite to the scene
	c_weapon_spot.add_child(weapon_sprite)
	c_weapon_spot.move_child(weapon_sprite,0) #Move sprite to be 1st child, to be before the number
	self.add_child(c_weapon_spot)

func get_scale_factor(c_size,target_size):
	var delta_size = c_size - target_size
	var delta_scale_factor = delta_size/c_size
	return (1-delta_scale_factor)