extends Node2D
var world
var kobuge_logo
var animations
var bg_color
var background
var godot_engine_group
var tween = Tween.new()
var timer = Timer.new()

func _init():
	add_child(tween)
	add_child(timer)

func _ready():
	world = get_node("../")
	kobuge_logo = get_node("IntroAnimation/KobugeLogo")
	godot_engine_group = get_node("IntroAnimation/GodotEngineGroup")
	animations = get_node("IntroAnimation/AnimationPlayer")
	bg_color = get_node("IntroAnimation/BgColor")
	background = get_node("Background")
	animations.connect("finished", self, "intro1")
	animations.play("logo_fade_in")
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if(Input.is_action_pressed("ui_accept")):
		set_process_input(false)
		go_to_menu()

func _fixed_process(delta):
	var screen_size = OS.get_window_size()
	kobuge_logo.set_global_pos( screen_size/2 )
	godot_engine_group.set_global_pos(screen_size/2)
	var polys_pos = bg_color.get_polygon()
	polys_pos[1] = Vector2(0,screen_size.y)
	polys_pos[2] = Vector2(screen_size.x,screen_size.y)
	polys_pos[3] = Vector2(screen_size.x,0)
	bg_color.set_polygon(polys_pos)
	bg_color.set_global_pos(Vector2(0,0))

func intro1():#KOBUGE logo Fade in
	animations.disconnect("finished",self, "intro1")
	animations.play("logo_fade_out")
	animations.connect("finished", self, "intro2")

func intro2():#KOBUGE logo Fade out
	animations.disconnect("finished",self, "intro2")
	animations.play("bg_white_to_black")
	animations.connect("finished", self, "intro3")

func intro3():#BG turn black
	animations.disconnect("finished",self, "intro3")
	animations.play("powered_fade_in")
	animations.connect("finished", self, "intro4")

func intro4():#Godot engine fade in
	animations.disconnect("finished",self, "intro4")
	animations.play("godotEngine_fade_in")
	animations.connect("finished", self, "intro5")

func intro5():#Godot engine group (with powered label) fade out
	animations.disconnect("finished",self, "intro5")
	animations.play("godotEngineGroup_fade_out")
	animations.connect("finished", self, "intro6")

func intro6():
	animations.disconnect("finished",self, "intro6")
	background.hide_particles(true)
	animations.play("bg_fade_out")
	animations.connect("finished", self, "go_to_menu")

func go_to_menu():
	get_tree().change_scene("res://scenes/menu/menu.xml")
	pass

