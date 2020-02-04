extends Spatial

func _on_unpause_pressed():
	get_node("../UI/pause_popup").hide()
	get_tree().set_pause(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if (Input.is_action_pressed("pause")):
		get_node("../UI/pause_popup").set_exclusive(true)
		get_node("../UI/pause_popup").popup()
		get_tree().set_pause(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_quit_pressed():
	get_tree().quit()