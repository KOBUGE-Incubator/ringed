extends "enemy_1.gd" # It has all the variables we need to make damange
var spider_explote_ID = null # The ID of the actual explote sound
var it_explotes = false # To know if the Kamikaze explotes


func _ready():
	set_points(250) # Set the points that this enemy give us
	animations = get_node("AnimatedSprite/AnimationPlayer")
	._ready()

func logic(delta): # We override the function defined in moveable_object.gd
	.logic(delta) # The enemy_1 method
	if(is_attaking == true): # The spider are now atacking
		do_kamikaze()
	if(it_explotes == true): # The spider explotes 
		if(!spider_sound.is_voice_active(spider_explote_ID)): # The explotion sound is over... time to die
			health = -1 # This make the spider die
			die() # kill the spider

func do_kamikaze():
	spider_sound.stop_voice(spider_sound_ID) # We stop the original spider sound
	if(spider_explote_ID == null): # If is the first and onlne time that the spider attacks
		if(!spider_sound.is_voice_active(spider_sound_ID)): # Is the orginial spider sound stoped
			spider_explote_ID = spider_sound.play("spider_explote") # Reproduces spider explotion sound
			animations.play("die") # Play de spider dead animation
			disable_spider()
			it_explotes = true

func die():
	if(!it_explotes): 
		do_kamikaze()
	if(!spider_sound.is_voice_active(spider_explote_ID)):
		add_player_points()
		self.queue_free()