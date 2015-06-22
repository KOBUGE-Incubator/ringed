extends Node2D

var hour # The hour that the class has
var minutes # The minutes that the class has 
var modulate_day # The CanvasModulate node that was passed to the class
var day_atenuation # The atenuation value used in modulate_day node (R,G,B)
var max_illumination = 1.0 # The max value that we can pass to the day_atenuation (RGB) 1.0 is actually the max
var min_illumination = 0.0 # The min value that we can pass to the day_atenuation (RGB) 0.0 is actually the min
var day = 0 # This will be +1 each time the clock pass from 23:59 to 00:00
var day_time = { # The time of the day (like we talk)
"morning":1,
"afternoon":2,
"evening":3,
"night":4
}
var current_day_time # It saves the range in where the ingresed time is

func _init(modulate, hour , mins , day): # Constructor of the class
	self.modulate_day = modulate # Get the CanvasModulate
	set_hour(hour) # We set the hour to the class variable and get the current_day_time
	set_mins(mins) # We set the minutes to the class variable
	self.day = day

func set_hour(hours): # We filter the ingresed hour, if is a valid one it return 1 and 0 if not
	if(hours >=0 and hours < 24):
		self.hour = hours
		if(hours >= 0 and hours <= 11 ): # These conditionals are to know in what range the ingresed hour is located
			current_day_time = day_time["morning"]
		elif (hours >= 12 and hours <= 17):
			current_day_time = day_time["afternoon"]
		elif (hours >= 18 and hours <= 22):
			current_day_time = day_time["evening"]
		elif (hours == 23):
			current_day_time = day_time["night"]
		return 1
	elif (hours == 24): 
		self.hour = 0
		self.day +=1
		return 1
	else:
		return 0

func set_mins(mins): # Little filter for the minutes, if is a valid number it returns 1 and 0 if not
	if(mins<60):
		self.minutes = mins
		set_ambient() # Set the Color of the modulate_day node (based on the time that is ingresed)
		return 1
	elif (mins == 60):
		self.minutes = 0
		self.hour += 1
		set_hour(self.hour)
		set_ambient() # Set the Color of the modulate_day node (based on the time that is ingresed)
		return 1
	else:
		return 0

func set_ambient(): # With this method we set the actual scene day color based in the hour that is in the class object
#morning - afternoon  from min_illumination to max_illumination in max_illumination/18 steps (00:00 - 17:59)
#evening - night from max_illumination to min_illumination in in max_illumination/6 steps (18:00 - 23:59)
	if(self.hour >= 0 and self.hour <= 17): # up , sun rises
		var min_steps = (self.max_illumination/18.0)/60.0
		self.day_atenuation = ( self.hour * (self.max_illumination/18.0) ) + (self.minutes * min_steps)
	elif(self.hour >= 18 and self.hour <= 23): #down , the sun sets
		var min_steps = (self.max_illumination/6.0)/60.0
		self.day_atenuation = self.max_illumination - (( (self.hour-18.0) * (self.max_illumination/6.0) ) + (self.minutes * min_steps)) + (self.min_illumination)
	if(day_atenuation > self.max_illumination): # In case the addition doesn't give us an exact max_illumination
		self.day_atenuation = self.max_illumination
	if(day_atenuation < self.min_illumination): # In case the subtraction doesn't give us an exact min_illumination
		self.day_atenuation = self.min_illumination
	self.modulate_day.set_color(Color(day_atenuation,day_atenuation,day_atenuation)) # We set the same value in RGB to get grey values

func get_day_time(): # In case we need to know in what time of the day is the actual class object
	return current_day_time
	
func what_time_is(): # Just to get the hour and minutes of the actual class object (in a string "hour:minutes")
		return str(self.hour)+":"+str(self.minutes)

func what_day_is(): # Just to get the actual day of the class object
	return self.day