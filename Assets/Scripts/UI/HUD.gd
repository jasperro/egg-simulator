extends Control

func _on_unpause_pressed():
	get_node("pause_popup").hide()
	get_tree().set_pause(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _pause_game():
	get_node("pause_popup").set_exclusive(true)
	get_node("pause_popup").popup()
	get_tree().set_pause(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if (Input.is_action_pressed("escape")):
		_pause_game()

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().get_root().add_child(load("res://Assets/UI/MainMenu.tscn").instance())
	get_tree().get_root().remove_child(get_node("/root/World"))
