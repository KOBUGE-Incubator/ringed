
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

func _ready():
	world = get_node("../")
	controls = world.get_node("Menu")
	bg = get_node("Sprite")
	bg_art = world.get_node("ParallaxBackground/ParallaxLayer1")
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
	var middle_pos = Vector2(width/2, height/2)
	kobuge_logo.set_global_pos( middle_pos )
	godot_engine_group.set_global_pos(middle_pos)
	var press_enter_pos = middle_pos
	press_enter_pos.x = (width/2)-(press_enter_label.get_size().x /2)
	press_enter_pos.y = height-50
	press_enter_label.set_global_pos(press_enter_pos)
	press_enter_label_done.set_global_pos(press_enter_pos)
	var polys_pos = bg_color.get_polygon()
	polys_pos[1] = Vector2(0,height)
	polys_pos[2] = Vector2(width,height)
	polys_pos[3] = Vector2(width,0)
	bg_color.set_polygon(polys_pos)
	if(Input.is_action_pressed("ui_accept")):
		if(is_in_press_enter):
			press_enter_label_done.show()
			animations.connect("finished", self, "intro8")
			animations.play("press_enter_done")
		else:
			interrupted = true
			intro7()
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
#		animations.stop_all()
		self.hide()
	animations.disconnect("finished",self, "intro7")
	animations.play("press_enter_idle")
	is_in_press_enter = true
	
func intro8():
	animations.disconnect("finished",self, "intro8")
	animations.connect("finished", self, "intro9")
	animations.play("bg_blur")

func intro9():
	controls.show()
	animations.disconnect("finished",self, "intro9")
	animations.connect("finished", self, "intro10")
	animations.play("menu_buttons_anim_in")

func intro10():
	pass
