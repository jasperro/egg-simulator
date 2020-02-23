extends PopupPanel

func _level_won():
	set_exclusive(true)
	popup()
	#get_tree().set_pause(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"../CollectionCounter".visible = false
	$"../TimerCounter".visible = false
