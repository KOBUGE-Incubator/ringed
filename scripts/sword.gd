
extends Node2D

export var damage = 10.0 # Amount of damage per hit
export var damage_percent_idle = 0.1 # Percent of damage to apply while not swinging
export var extent = 90.0 # Max +/- degree
export var swing_cooldown = 1.0 # Time (sec) between two swings
export var swing_speed = 0.35 # Speed of swing in seconds
export var normalize_speed = 60.0 # The speed with which the target_angle goes back to 0
export var damage_speed = 60.0 # The speed with which damage_multiplier goes to damage_percent_idle
export var highlight_holdness = 1.0 # The highlight follow speed in seconds + or - the swing speed
var sword_area
var highlight
var damage_multiplier = 0.0
var target_angle = 0.0
var target_dir = 1
var swing_time_left = 0.0
var animation
var tween = Tween.new()

func _init():
	add_child(tween)

func _ready():
	sword_area = get_node("Sword")
	highlight = get_node("Highlight")
	animation = get_node("Highlight/Animation")
	sword_area.connect("body_enter", self, "hit")
#	set_process(true)
	animation.play("blink")
	set_fixed_process(true)

#func _process(delta):
	# Interpolate the angle
#	pass
#	var t_dir = Vector2(0,1).rotated(sword_area.get_rot()) # We make a unit vector (one that has a length of one) poiting in the final direction
#	var c_dir = Vector2(0,1).rotated(highlight.get_rot()) # Then we make another unit vector in the current direction
#	c_dir = c_dir.linear_interpolate(t_dir, highlight_holdness * delta) # We interpolate between them
#	highlight.set_rot(atan2(c_dir.x,c_dir.y)) # Then we use the angle of the interpolated vector as the rotation

func shot():
	if(swing_time_left <= 0):
		target_angle = target_dir * extent
		target_dir = -target_dir
		damage_multiplier = 1.0
		make_swing()
		swing_time_left = swing_cooldown

func _fixed_process(delta):
	swing_time_left -= delta
#	# Interpolate the angle
#	var t_dir = Vector2(0,1).rotated(target_angle) # We make a unit vector (one that has a length of one) poiting in the final direction
#	var c_dir = Vector2(0,1).rotated(sword_area.get_rot()) # Then we make another unit vector in the current direction
#	c_dir = c_dir.linear_interpolate(t_dir, swing_speed * delta) # We interpolate between them
#	sword_area.set_rot(atan2(c_dir.x,c_dir.y)) # Then we use the angle of the interpolated vector as the rotation
#	target_angle = lerp(target_angle, 0.0, normalize_speed*delta)
	damage_multiplier = lerp(damage_multiplier, damage_percent_idle, damage_speed*delta)

func hit(other):
	if(is_visible()):
		if(other.has_method("damage")):
			other.damage("player", damage * damage_multiplier)

func make_swing():
	var start_angle_sword = sword_area.get_rot()
	var end_angle_sword = start_angle_sword - ((target_dir*extent)/100)
	tween.interpolate_method(sword_area, "set_rot", start_angle_sword , end_angle_sword, swing_speed , tween.TRANS_QUART, tween.EASE_OUT)
	tween.interpolate_method(highlight, "set_rot",start_angle_sword, end_angle_sword, swing_speed + highlight_holdness , tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()

