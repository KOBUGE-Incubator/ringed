
extends Button

var tween = Tween.new()
var orignial_position = Vector2()
var animation_time = 0.5
var animation_time_entrance = 0.3
var tag
var tag_color
var tag_color_select
var offset_distance = 35
var entrance_offset_distance = 60
export var entrance = false

func _init():
	add_child(tween)

func _ready():
	check_entrance()
	tag = self.get_node("tag")
	tag_color = tag.get_color()
	tag_color_select = Color(211.0,169.0,0,1)
	orignial_position = self.get_pos()
	self.connect("mouse_enter",self,"hover_in")
	self.connect("mouse_exit",self,"hover_out")
	get_viewport().connect("size_changed", self, "size_changed")

func hover_in():
	var end_position = orignial_position
	end_position.x = end_position.x + offset_distance
	tween.interpolate_method(self, "set_pos", orignial_position , end_position, animation_time , tween.TRANS_QUART, tween.EASE_OUT)
	tween.interpolate_method(tag, "set_color", tag_color , tag_color_select, animation_time , tween.TRANS_LINEAR, tween.EASE_IN_OUT)
	tween.start()

func hover_out():
	tween.interpolate_method(self, "set_pos", self.get_pos() , orignial_position, animation_time , tween.TRANS_QUART, tween.EASE_OUT)
	tween.interpolate_method(tag, "set_color", tag_color_select , tag_color, animation_time , tween.TRANS_LINEAR, tween.EASE_IN_OUT)
	tween.start()

func size_changed():
	orignial_position = self.get_pos()

func check_entrance():
	if(entrance):
		self.set_opacity(0)

func make_entrance():
	var entrance_pos = self.get_pos()
	entrance_pos.y += entrance_offset_distance
	tween.interpolate_method(self, "set_pos", entrance_pos , orignial_position, animation_time_entrance , tween.TRANS_QUART, tween.EASE_OUT)
	tween.interpolate_method(self, "set_opacity", self.get_opacity() , 1 , animation_time_entrance , tween.TRANS_QUART, tween.EASE_OUT)
	tween.start()