# living_object.gd -> moveable_object.gd -> RigidBody2D
extends "moveable_object.gd" # Thing that are alive can move

export var heal_cooldown = 0.2 # Time between two succesive auto-heals, or between a damage and an auto-heal
export var max_health = 6.0 # The maximum amount of health the creature can have
var health # The amount of health
export var hide_when_full = false # Should we hide the healthbar when it is full?
var healthbar # The healthbar node
var healthbar_region # The original region rect of the healthbar
var healthbarHolder # The node that holder the healthbar (used for rotation)
var time_for_next_heal = 0.0 # Time left till the next auto-heal

func _ready():
	healthbarHolder = get_node("HealthHolder") # Take the healthbar holder node
	healthbar = get_node("HealthHolder/HealthBar") # Take the healthbar itself
	
	health = max_health # Reset the health
	healthbar_region = healthbar.get_region_rect() # Get the current region rect
	if(hide_when_full):
		healthbarHolder.hide() # Hide the healthbar
	else:
		healthbarHolder.show() # Show the healthbar
	
	set_process(true) # We use _process for rotation of the healthbar, so it remains upright
	set_fixed_process(true) # We use _fixed_process for auto-heals
	

func _process(delta):
	healthbarHolder.set_rot(-get_rot()) # Just rotate in the opposite direction to get back to 0 degrees

func _fixed_process(delta):
	time_for_next_heal -= delta # We decrease the time till the next auto-heal by the time elapsed
	
	if(time_for_next_heal <= 0):
		heal(1) # Auto-heal the creature
		time_for_next_heal = heal_cooldown # We restart the auto-heal timer

func update_health(): # Update the healthbar (or die)
	var new_region = healthbar_region # Take the original region
	new_region.size.x *= health/max_health # Resize the region on X
	healthbar.set_region_rect(new_region) # Apply the new region
	if(health <= 0):
		die() # Die when no health is left
	if(hide_when_full && health >= max_health): # When we should hide the healthbar, and we have full health
		healthbarHolder.hide() # Hide
	else:
		healthbarHolder.show() # Show

func heal(amount): # Heal by a given amount
	health = min(health + amount, max_health) # Make sure not to get over max_health
	update_health() # Update the healthbar
	
func amount_of_damage(from): # Returns a value from 0 to 1 (float) if damaged (how many percent), or returns 0 (int) if no damage is taken
	return 1.0 # Get full (1.0 == 100%) damage from everything

func damage(from, amount): # Damage the creature from a given source
	var percent = amount_of_damage(from) # Percent of damage we will get
	if(percent != 0):
		health =  max(health - percent * amount , -0.1) # Make sure not to get under 0
		time_for_next_heal = heal_cooldown # Reset the auto-heal timer
		update_health() # Update the healthbar
		return true # Say that the creature was damaged
	return false # Say that the damage attempt was unsuccessful 

func die():
	queue_free() # Just delete the object when dead

