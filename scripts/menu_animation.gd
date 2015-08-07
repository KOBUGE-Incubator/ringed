extends ParallaxLayer
var world
var controls
var bg
var bg_art
var press_enter_label
var press_enter_label_done
var kobuge_logo
var animations
var bg_color
var godot_engine_group
var is_in_press_enter = false
var interrupted = false
var btn_join
var btn_host
var btn_options
var prev_enter=false
var particles
var tween = Tween.new()
var timer = Timer.new()

func _init():
	add_child(tween)
	add_child(timer)

func _ready():
	world = get_node("../")
	controls = world.get_node("Menu")
	btn_join = controls.get_node("Main/Join")
	btn_host = controls.get_node("Main/Host")
	btn_options = controls.get_node("Main/Options")
	bg = get_node("Sprite")
	bg_art = world.get_node("ParallaxBackground/ParallaxLayer1")
	particles = world.get_node("ParallaxBackground/Particles")
	kobuge_logo = get_node("KobugeLogo")
	godot_engine_group = get_node("GodotEngineGroup")
	press_enter_label = bg_art.get_node("pressENTER")
	press_enter_label_done = bg_art.get_node("pressENTER_done")
	animations = get_node("AnimationPlayer")
	bg_color = get_node("BgColor")
	animations.connect("finished", self, "intro1")
	animations.play("logo_fade_in")
	controls.hide()
	bg.hide()
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	pass

func _fixed_process(delta):
	var screen_size = OS.get_window_size()
	var width = int(screen_size.x)
	var height = int(screen_size.y)
	var mid_width = width/2
	var mid_height = height/2
	var middle_pos = Vector2(mid_width, mid_height)
	kobuge_logo.set_global_pos( middle_pos )
	godot_engine_group.set_global_pos(middle_pos)
	var press_enter_pos = middle_pos
	press_enter_pos.x = (mid_width)-(press_enter_label.get_size().x /2)
	press_enter_pos.y = height-50
	press_enter_label.set_global_pos(press_enter_pos)
	press_enter_label_done.set_global_pos(press_enter_pos)
	var particles_pos = middle_pos
	particles_pos.y = height + 50
	particles.set_global_pos(particles_pos)
	var part1_pos = particles.get_node("1").get_global_pos()
	part1_pos.x = 0
	var part2_pos = particles.get_node("2").get_global_pos()
	part2_pos.x = mid_width
	var part3_pos = particles.get_node("3").get_global_pos()
	part3_pos.x = width
	particles.get_node("1").set_global_pos(part1_pos)
	particles.get_node("2").set_global_pos(part2_pos)
	particles.get_node("3").set_global_pos(part3_pos)
	var polys_pos = bg_color.get_polygon()
	polys_pos[1] = Vector2(0,height)
	polys_pos[2] = Vector2(width,height)
	polys_pos[3] = Vector2(width,0)
	bg_color.set_polygon(polys_pos)
	bg_color.set_global_pos(Vector2(0,0))
	var enter = Input.is_action_pressed("ui_accept")
	if(enter and not prev_enter):
		if(is_in_press_enter):
			press_enter_label_done.show()
			animations.connect("finished", self, "intro8")
			animations.play("press_enter_done")
		elif (is_in_press_enter == false and interrupted == false):
			interrupted = true
			intro7()
	prev_enter = enter

func intro1():#KOBUGE logo Fade in
	animations.disconnect("finished",self, "intro1")
	animations.connect("finished", self, "intro2")
	animations.play("logo_fade_out")

func intro2():#KOBUGE logo Fade out
	animations.disconnect("finished",self, "intro2")
	animations.connect("finished", self, "intro3")
	animations.play("bg_white_to_black")

func intro3():#BG turn black
	animations.disconnect("finished",self, "intro3")
	animations.connect("finished", self, "intro4")
	animations.play("powered_fade_in")

func intro4():
	animations.disconnect("finished",self, "intro4")
	animations.connect("finished", self, "intro5")
	animations.play("godotEngine_fade_in")

func intro5():
	animations.disconnect("finished",self, "intro5")
	animations.connect("finished", self, "intro6")
	animations.play("godotEngineGroup_fade_out")

func intro6():
	animations.disconnect("finished",self, "intro6")
	animations.connect("finished", self, "intro7")
	bg_art.show()
	press_enter_label.show()
	animations.play("bg_fade_out")

func intro7():
	if(interrupted):
		animations.stop(true)
		self.hide()
		press_enter_label.show()
		animations.disconnect("finished",self, "intro7")
		interrupted = null
		animations.play("press_enter_idle")
		is_in_press_enter = true
	elif (interrupted == false):
		animations.disconnect("finished",self, "intro7")
		animations.play("press_enter_idle")
		is_in_press_enter = true

func intro8():
	press_enter_label.hide()
	press_enter_label_done.hide()
	is_in_press_enter = null
	animations.stop(true)
	animations.disconnect("finished",self, "intro8")
	animations.play("bg_blur")
	animations.connect("finished", self, "intro9")
	controls.show()
	btn_join.set_opacity(0)
	btn_host.set_opacity(0)
	btn_options.set_opacity(0)
	

func intro9():
	animations.stop(true)
	animations.disconnect("finished",self, "intro9")
	animations.connect("finished", self, "intro10")
#	animations.play("menu_buttons_anim_in")
	animate_button(btn_join, 2)
	timer.set_one_shot(true)
	timer.set_wait_time(.2)
	timer.start()
	yield(timer,'timeout')
	animate_button(btn_host, 2)
	timer.start()
	yield(timer,'timeout')
	animate_button(btn_options, 2)

func intro10():
	pass

func animate_button(button, time):
	var button_pos_final = button.get_global_pos()
	var button_pos_initial = button_pos_final
	button_pos_initial.y = button_pos_initial.y+20 
	tween.interpolate_method(button, "set_global_pos", button_pos_initial, button_pos_final, time, tween.TRANS_QUART, tween.EASE_OUT)
	tween.interpolate_method(button, "set_opacity", 0 , 1, time , tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()