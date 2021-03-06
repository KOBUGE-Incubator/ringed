# enemy_1.gd -> living_object.gd -> moveable_object.gd -> RigidBody2D
extends "living_object.gd" # Spiders are living objects too...

export var cooldown = 0.2 # Time between two damages
export var damage = 1.0 # The amount of damage we do
export var prob_drop_item = 0.5 
export var sound_die = ""
var cooldown_left = 0.0 # Time left till the next damage
var is_attaking = false # To know when the spider is attaking
var spider_sound # The sounds of the spiders
var spider_sound_ID # The ID of the spider
var player # The player node
export var points = 100 # The amount of points that the enemy give us
var animations

func _ready():
	add_to_group("enemies") # Mark it as an enemy
	spider_sound = get_node("SpiderSound")
	spider_sound_ID = spider_sound.play("spider_sound")
	animations = get_node("AnimatedSprite/AnimationPlayer")
	animations.play("walking")
	animations.seek(randf() * animations.get_current_animation_length())


func logic(delta): # We override the function defined in moveable_object.gd
	cooldown_left -= delta # Decrease the cooldown by the time elapsed
	if(player == null):
		player =  get_node("../../player")
		var enemylabel = get_node("../../HUD/enemys")
		enemylabel.set_text(str(int(enemylabel.get_text())+1))
	target_angle = get_pos().angle_to_point(player.get_pos() ) + deg2rad(0) # Turn towards the player
	force = Vector2(0,-1).rotated(target_angle) # and move in that same direction
	
	for body in get_colliding_bodies(): # Get all colliding bodies
		if(body.has_method("damage") && cooldown_left <= 0):
			if(body.damage(self,damage)): # If we can damage them
				is_attaking = true # The spider is attaking!
				cooldown_left = cooldown # Increase the timeout
		else:
			is_attaking = false

func amount_of_damage(from): # We override the function defined in living_object.gd
#	if(from.get_name() != "spider"):
	if(from.has_method("add_points")):
		return 1.0 # We can't get damaged by other spiders...
	return 0

func get_points():
	return points

func set_points(points_new):
	points = points_new

func disable_spider():
	set_layer_mask(0) # Disable Collisions
	set_collision_mask(0) # Disable Collisions
	healthbarHolder.hide()
	healthbar.hide()
	health_empty.hide()
	damage = 0
	speed = 0
	rotation_speed = 0

func die():
	disable_spider()
	add_player_points()
	spider_sound.play(sound_die)
	animations.connect("finished", self, "end_die_animation")
	animations.play("die")
	drop_item()

func end_die_animation():
	queue_free()

func drop_item():
	var r_number = rand_range(0.0,1.0)
	if(r_number <= prob_drop_item):
		var items = get_node("/root/autoload_items").consumable_items
		var item_index = randi() % items.size()
		var item = items[item_index].instance()
		item.set_global_pos(self.get_global_pos())
		self.get_parent().add_child(item)