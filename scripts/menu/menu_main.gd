
extends Control

var btn_join
var btn_host
var btn_options
var array_btns
var delay_between_entrances = 0.2
var delay_start_entrance = 1.0
var timer = Timer.new()

func _init():
	add_child(timer)

func _ready():
	btn_join = get_node("Join")
	btn_host = get_node("Host")
	btn_options = get_node("Options")
	array_btns = [btn_join,btn_host,btn_options]

func make_entrance():
	timer.set_one_shot(true)
	timer.set_wait_time(delay_start_entrance)
	timer.start()
	yield(timer,'timeout')
	timer.set_wait_time(delay_between_entrances)
	for btn in array_btns:
		btn.make_entrance()
		timer.start()
		yield(timer,'timeout')
