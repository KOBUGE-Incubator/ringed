
extends Control

const OPTION_TYPE_CHECKBOX = 1
const OPTION_TYPE_MENU     = 2

var options = [ # Explain the different options to the script
	{
		"name": "Fullscreen",
		"type": OPTION_TYPE_CHECKBOX,
		"setting": "fullscreen"
	},
	{
		"name": "Bullet Lights",
		"type": OPTION_TYPE_MENU,
		"setting": "bullets",
		"options": {
			"2": "Full",
			"1": "Simple",
			"0": "Off"
		},
		"data_type": TYPE_INT
	}
]
var options_config = {
	"height": 52
}


# Global Settings
var global 

func _ready():
	global = get_node("/root/global")
	
	for child in get_node("Options").get_children():
		child.queue_free()
	
	var values = {
		"fullscreen": global.fullscreen,
		"bullets": global.bullets
	}
	create_menu(get_node("Options"), options, options_config, values)

func create_menu(root, menu, config, values):
	if(!config.has("height")):
		config.height = 10
	var offset = 0
	
	for setting in menu:
		offset += config.height
		
		var setting_node = make_setting_node(setting, offset, config.height, values[setting.setting])
		root.add_child(setting_node)

func make_setting_node(options, offset, height, value):
	var node = Control.new()
	node.set_anchor_and_margin(MARGIN_LEFT, ANCHOR_BEGIN, 0)
	node.set_anchor_and_margin(MARGIN_RIGHT, ANCHOR_END, 0)
	node.set_anchor_and_margin(MARGIN_TOP, ANCHOR_BEGIN, offset)
	node.set_anchor_and_margin(MARGIN_BOTTOM, ANCHOR_BEGIN, offset + height)
	
	var label = Label.new()
	label.set_name("Label")
	label.set_anchor_and_margin(MARGIN_LEFT, ANCHOR_BEGIN, 0)
	label.set_anchor_and_margin(MARGIN_RIGHT, ANCHOR_CENTER, 0)
	label.set_anchor_and_margin(MARGIN_TOP, ANCHOR_BEGIN, 0)
	label.set_anchor_and_margin(MARGIN_BOTTOM, ANCHOR_END, 0)
	label.set_text(options.name)
	node.add_child(label)
	
	var control = null
	
	if(options.type == OPTION_TYPE_CHECKBOX):
		control = CheckBox.new()
		control.set_text("On")
		control.set_pressed(value)
		control.connect("toggled", self, "checkbox_change", [options.setting])
	if(options.type == OPTION_TYPE_MENU):
		control = OptionButton.new()
		var selected = -1
		var n = 0
		var values_array = []
		for i in options.options:
			control.add_item(options.options[i])
			if(convert(i, options.data_type) == convert(value, options.data_type)):
				selected = n
			n += 1
			values_array.push_back(convert(i, options.data_type))
		control.select(selected)
		control.connect("item_selected", self, "option_button_change", [options.setting, values_array])
	
	if(control):
		control.set_name("Control")
		control.set_anchor_and_margin(MARGIN_LEFT, ANCHOR_CENTER, 0)
		control.set_anchor_and_margin(MARGIN_RIGHT, ANCHOR_END, 0)
		control.set_anchor_and_margin(MARGIN_TOP, ANCHOR_BEGIN, 0)
		control.set_anchor_and_margin(MARGIN_BOTTOM, ANCHOR_END, 0)
	
		node.add_child(control)
	return node

func checkbox_change(state, setting_name):
	global.save_to_config("display", setting_name, state)
	
func option_button_change(state, setting_name, setting_values):
	global.save_to_config("display", setting_name, setting_values[state])

#func set_fullscreen(flag):
#	global.fullscreen = flag
#	OS.set_window_fullscreen(global.fullscreen)
#	global.save_to_config("display", "fullscreen", flag)
#