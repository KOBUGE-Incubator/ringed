extends "enemy_1.gd" # It has all the variables we need to make damange
var spider_explote_ID = null # The ID of the actual explote sound
var it_explotes = false # To know if the Kamikaze explotes
var spider_animations # The animations of the kamikaze spider
var health_empty # The health node when its empty

func _ready():
	spider_animations = get_node("AnimatedSprite/AnimationPlayer")
	health_empty = get_node("HealthHolder/HealthEmpty")
	._ready()
func logic(delta): # We override the function defined in moveable_object.gd
	.logic(delta) # The enemy_1 method
	if(is_attaking == true): # The spider are now atacking
		do_kamikaze()
	if(it_explotes == true): # The spider explotes 
		if(!spider_sound.is_voice_active(spider_explote_ID)): # The explotion sound is over... time to die
			print("audio finalizo")
			health = -1 # This make the spider die
	
func do_kamikaze():
	spider_sound.stop_voice(spider_sound_ID) # We stop the original spider sound
	if(spider_explote_ID == null): # If is the first and onlne time that the spider attacks
		if(!spider_sound.is_voice_active(spider_sound_ID)): # Is the orginial spider sound stoped
			spider_explote_ID = spider_sound.play("spider_explote") # Reproduces spider explotion sound
			spider_animations.play("die") # Play de spider dead animation
			set_layer_mask(0) # Disable Collisions
			set_collision_mask(0) # Disable Collisions
			disable_spider()
			it_explotes = true
func disable_spider():
	healthbarHolder.hide()
	healthbar.hide()
	health_empty.hide()
	damage = 0
	speed = 0
	rotation_speed = 0

