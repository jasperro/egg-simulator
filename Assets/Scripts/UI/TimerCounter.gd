extends Label

var startticks := 0
var leveltime := 0
var stop := false

func _ready():
	_reset()

func _reset():
	startticks = Time.get_ticks_msec()

func _physics_process(_delta):
	leveltime = Time.get_ticks_msec() - startticks
	if stop != true:
		set_text(str(snapped((float(leveltime)/1000),0.1)) + "s")
