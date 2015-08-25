extends Node2D

var animations
var sounds
var sounds_pickup_ID
var area
var is_picked = false
var timer = Timer.new()
export var life_time = 2.5 
export(String, "SPECIAL", "AMMO") var type 
export var affect = ""
export var quantity = 0
export var sound_name = "pickup_ammo"

func _ready():
	set_life_timer(life_time)
	animations = get_node("AnimationPlayer")
	sounds = get_node("SamplePlayer2D")
	area = get_node("Area2D")
	area.connect("body_enter",self,"pickup_affect")

func set_life_timer(time):
	if(time > 0 ):
		add_child(timer)
		timer.set_one_shot(true)
		timer.set_wait_time(time)
		timer.connect("timeout",self,"life_ends")
		timer.start()

func pickup_affect(body):
	if(body.get("can_pickup")): # The object that enters has this variable in true
		print(body.get_type())
		print(type)
		if(type == 'AMMO'):
			var guns = body.get_node("Guns")
			if(guns): # It has a Guns node group
				var gun = guns.get_node(affect)
				if(gun): # It was found in that group
					gun.add_ammo(quantity)
				else:
					return
			else:
				return
		elif(type == 'SPECIAL'):
				var first = affect.substr(0,1)
				if(first == "."):
					var affect_method = affect.substr(1,affect.length())
					body.call(affect_method,quantity)
				else:
					if(body.get(affect) != null): # It has the variable
						body.set(affect,quantity)
		start_pickup()

func start_pickup():
	is_picked = true
	area.disconnect("body_enter",self, "pickup_affect")
	animations.connect("finish",self,"end_pickup")
	animations.play("pickup")
	sounds_pickup_ID = sounds.play(sound_name)

func end_pickup():
	if(!sounds.is_voice_active(sounds_pickup_ID)):
		self.queue_free()
	else:
		end_pickup()

func life_ends():
	if(!is_picked):
		start_pickup()