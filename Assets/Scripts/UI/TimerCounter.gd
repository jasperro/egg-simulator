extends Label

var startticks
var leveltime
var stop = false

func _ready():
	_reset()

func _reset():
	startticks = OS.get_ticks_msec()

func _physics_process(_delta):
	leveltime = OS.get_ticks_msec() - startticks
	if stop != true:
		set_text(str(stepify((float(leveltime)/1000),0.1)) + "s")
