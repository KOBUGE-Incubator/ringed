# living_object.gd -> moveable_object.gd -> RigidBody2D
extends "moveable_object.gd" # Thing that are alive can move

export var infinite_stamina = true # If this option is false, the scene tree needs the nodes StaminaHolder/StaminaBar and StaminaHolder
export var stamina_cooldown = 0.2 # Time between two succesive stamina-recover, or between a run and and stamina-recover
export var max_stamina = 6.0 # The maximum amount of stamina the creature can have
export var stamina_recover_amount = 1.0 # How much stamina the creature will recover over the time specified
var stamina # The amount of stamina
export var hide_staminabar_when_full = false # Should we hide the stamina bar when it is full?
var staminabar # The staminabar node
var staminabarHolder # The node that holder the staminabar (used for rotation)
var time_for_next_stamina_recover = 0.0 # Time left till the next stamina-recover
var is_tired = false # To know if the object is tired

export var heal_cooldown = 0.2 # Time between two succesive auto-heals, or between a damage and an auto-heal
export var max_health = 6.0 # The maximum amount of health the creature can have
var health # The amount of health
export var hide_when_full = false # Should we hide the healthbar when it is full?
var healthbar # The healthbar node
var healthbar_scale
var healthbarHolder # The node that holder the healthbar (used for rotation)
var health_empty # The health node when its empty
var time_for_next_heal = 0.0 # Time left till the next auto-heal
var tween = Tween.new() # The Tween use to scale the life bar
export var time_bars_smooth = 1.0 # The time that the bars use in the tween  
var who_kill_me # It saves the node of the thing that give us damange, if we die it will get the points

func _init():
	add_child(tween) # We add the Tween node to the scene, this way we can use it to make the tween animations for the bars

func _ready():
	if (infinite_stamina == false): # We have to use stamina nodes
		staminabar = get_node("StaminaHolder/StaminaBar")
		staminabarHolder = get_node("StaminaHolder")
		stamina = max_stamina # Reset the stamina
		if(hide_staminabar_when_full):
			staminabarHolder.hide() # Hide the staminabar
		else:
			staminabarHolder.show() # Show the staminabar
	health = max_health
	healthbarHolder = get_node("HealthHolder") # Take the healthbar holder node
	healthbar = get_node("HealthHolder/HealthBar") # Take the healthbar itself
	healthbar_scale = healthbar.get_scale()
	health_empty = get_node("HealthHolder/HealthEmpty")
	if(hide_when_full):
		healthbarHolder.hide() # Hide the healthbar
	else:
		healthbarHolder.show() # Show the healthbar
	set_process(true) # We use _process for rotation of the healthbar, so it remains upright
	set_fixed_process(true) # We use _fixed_process for auto-heals

func _process(delta):
	var rotation = get_rot()
	healthbarHolder.set_rot(-rotation) # Just rotate in the opposite direction to get back to 0 degrees
	if(infinite_stamina == false):
		staminabarHolder.set_rot(-rotation) # Just rotate in the opposite direction to get back to 0 degrees

func _fixed_process(delta):
	if(infinite_stamina == false): # If the object has infinite stamina it wont access to the stamina-recover functions
		time_for_next_stamina_recover -= delta # We decrease the time till the next stamina-recover by the time elapsed
		if(time_for_next_stamina_recover <= 0):
			recover(stamina_recover_amount)# Auto-recover the creature
			time_for_next_stamina_recover = stamina_cooldown # We restart the auto-heal timer
	time_for_next_heal -= delta # We decrease the time till the next auto-heal by the time elapsed
	if(time_for_next_heal <= 0):
		heal(1) # Auto-heal the creature
		time_for_next_heal = heal_cooldown # We restart the auto-heal timer

func update_health(amount): # Update the healthbar (or die)
	tween.interpolate_method(healthbar, "set_scale", Vector2((health/max_health)*healthbar_scale.x,healthbar_scale.y), Vector2(get_porcent_life(amount)*healthbar_scale.x, healthbar_scale.y), time_bars_smooth, tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()
	if(health <= 0):
		die() # Die when no health is left
	if(hide_when_full && health >= max_health): # When we should hide the healthbar, and we have full health
		healthbarHolder.hide() # Hide
	else:
		healthbarHolder.show() # Show

func update_stamina(amount): # Update the staminabar (or will be empty)
	tween.interpolate_method(staminabar, "set_scale", Vector2(stamina/max_stamina,1), Vector2(get_porcent_stamina(amount), 1), time_bars_smooth, tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()
	if(stamina <= 0):
		tired(true) # Can move or dodge at full speed
	else:
		tired(false) # The object is not tired now
	if(hide_staminabar_when_full && stamina >= max_stamina): # When we should hide the staminabar, and we have full stamina
		staminabarHolder.hide() # Hide
	else:
		staminabarHolder.show() # Show
		
func heal(amount): # Heal by a given amount
	update_health(amount) # Update the healthbar

func recover(amount):
	update_stamina(amount) # Update the staminabar

func amount_of_damage(from): # Returns a value from 0 to 1 (float) if damaged (how many percent), or returns 0 (int) if no damage is taken
	return 1.0 # Get full (1.0 == 100%) damage from everything

func damage(from, amount): # Damage the creature from a given source
	var percent = amount_of_damage(from) # Percent of damage we will get
	if(percent != 0):
		who_kill_me = from
		time_for_next_heal = heal_cooldown # Reset the auto-heal timer
		update_health(-amount) # Update the healthbar
		return true # Say that the creature was damaged
	return false # Say that the damage attempt was unsuccessful 

func use_stamina (amount):
	if(amount != 0):
		time_for_next_stamina_recover = stamina_cooldown # Reset the auto-recover timer
		update_stamina(-amount) # Update the staminabar
		return true # Say that the creature use stamina
	return false # Say that the use of stamina attempt was unsuccessful 

func die():
	add_player_points()
	queue_free() # Just delete the object when dead

func add_player_points():
	if(who_kill_me != null):
		who_kill_me.add_points(self.points)

func tired(state):
	is_tired = state

func get_porcent_life (val):
	var temp_health = health
	temp_health += val
	if(temp_health > max_health):
		health = max_health
	elif(temp_health < 0):
		health = 0
	else:
		health += val
	var porcent = health/max_health
	return porcent

func get_porcent_stamina (val):
	var temp_stamina = stamina
	temp_stamina += val
	if(temp_stamina > max_stamina):
		stamina = max_stamina
	elif(temp_stamina < 0):
		stamina = 0
	else:
		stamina += val
	var porcent = stamina/max_stamina
	return porcent
