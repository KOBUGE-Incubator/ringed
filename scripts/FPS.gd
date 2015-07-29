extends Label

func _ready():
    set_process(true)

func _process(d):
    set_text(str(OS.get_frames_per_second()))