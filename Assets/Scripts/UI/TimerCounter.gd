extends Label

var startticks
var stop = false

func _ready():
	_reset()

func _reset():
	startticks = OS.get_ticks_msec()

func _physics_process(_delta):
	if stop != true:
		set_text(str(stepify((float(OS.get_ticks_msec() - startticks)/1000),0.1)) + "s")
