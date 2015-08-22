extends Node

	# Window variables
var width = 1024
var height = 768
var fullscreen = false
var bullets = 2
	# PATH variable
const settings_filename = "user://settings.cfg"

func _ready():
	load_config()
	# Handle display
	get_tree().connect("screen_resized", self, "save_screen_size")

func save_screen_size():
	var screen_size = OS.get_window_size()
	width = int(screen_size.x)
	height = int(screen_size.y)
	save_to_config("display", "width", width)
	save_to_config("display", "height", height)
	update_values(get_config_file())

func update_values(config):
	width = set_from_cfg(config, "display", "width", width)
	height = set_from_cfg(config, "display", "height", height)
	fullscreen = set_from_cfg(config, "display", "fullscreen", fullscreen)
	bullets = set_from_cfg(config, "display", "bullets", bullets)
	
	OS.set_window_size(Vector2(width, height))
	OS.set_window_fullscreen(fullscreen)

func get_config_file():
	var config = ConfigFile.new()
	var err = config.load(settings_filename)
	if (err):
		print("Error code when loading config file: ", err)
		return false
	else:
		return config
		
func save_to_config(section, key, value):
	var config = get_config_file()
	config.set_value(section, key, value)
	config.save(settings_filename)

func load_config():
	var config = ConfigFile.new()
	var err = config.load(settings_filename)
	if (err):
		# TODO: Better error handling
		# Config file does not exist, dump default settings in it
		
		# Display parameters
		config.set_value("display", "width", width)
		config.set_value("display", "height", height)
		config.set_value("display", "fullscreen", fullscreen)
		config.set_value("display", "bullets", bullets)
		config.save(settings_filename)
	else:
		# User-defined input actions overrides
		var event
		for action in config.get_section_keys("actions"):
			InputMap.erase_action(action)
			InputMap.add_action(action)
			InputMap.action_add_event(action, config.get_value("actions", action))
		
	update_values(config)

func set_from_cfg(config, section, key, fallback):
	if (config.has_section_key(section, key)):
		return config.get_value(section, key)
	else:
		print("Warning: '" + key + "' missing from '" + section + "'section in the config file, default value has been added.")
		save_to_config(section, key, fallback)
		return fallback