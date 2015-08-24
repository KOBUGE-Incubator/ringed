
extends Node2D

export var damage = 10.0 # Amount of damage per hit
export var damage_percent_idle = 0.1 # Percent of damage to apply while not swinging
export var extent = 90.0 # Max +/- degree
export var swing_cooldown = 1.0 # Time (sec) between two swings
export var swing_speed = 0.35 # Speed of swing in seconds
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
export var ammo = 0 
export var c_ammo = -1 # -1 for infinite ammo

func _init():
	tween.set_tween_process_mode(0) # This option makes that the tween use fixed process
	add_child(tween)

func _ready():
	sword_area = get_node("Sword")
	highlight = get_node("Highlight")
	animation = get_node("Highlight/Animation")
	sword_area.connect("body_enter", self, "hit")
	animation.play("blink")
	set_fixed_process(true)

func shot():
	if(swing_time_left <= 0): # To prevent ultra fast swings
		target_angle = target_dir * extent # The new angle
		target_dir = -target_dir # To switch the swing direction
		damage_multiplier = 1.0
		make_swing()
		swing_time_left = swing_cooldown # Reset the cooldown

func _fixed_process(delta):
	swing_time_left -= delta # When it is <= 0 we can make another swing
	damage_multiplier = lerp(damage_multiplier, damage_percent_idle, damage_speed*delta)

func hit(other):
	if(is_visible()):
		if(other.has_method("damage")):
			other.damage(get_parent().get_parent(), damage * damage_multiplier)

func make_swing():
	var start_angle_sword = sword_area.get_rot()
	var end_angle_sword = start_angle_sword - ((target_dir*extent)/100)
	tween.interpolate_method(sword_area, "set_rot", start_angle_sword , end_angle_sword, swing_speed , tween.TRANS_QUART, tween.EASE_OUT)
	tween.interpolate_method(highlight, "set_rot",start_angle_sword, end_angle_sword, swing_speed + highlight_holdness , tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()

