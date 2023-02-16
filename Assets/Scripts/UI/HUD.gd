extends Control

signal reset_level

func _ready():
	reset_level.connect(get_node("/root/World").current_egg.get_node("Egg")._reset_level)

func _on_unpause_pressed():
	get_node("pause_popup").hide()
	get_tree().set_pause(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _pause_game():
	get_node("pause_popup").show()
	get_tree().set_pause(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(_event):
	if (Input.is_action_pressed("escape")):
		_pause_game()

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_node("pause_popup").hide()
	get_node("pause_popup").set_exclusive(false)
	get_tree().set_pause(false)
	get_node("/root/Global/Vars").collectibles = 0
	get_node("/root/Global/Vars").collected = 0
	get_tree().get_root().add_child(load("res://Assets/UI/MainMenu.tscn").instantiate())
	get_tree().get_root().remove_child(get_node("/root/World"))

func _on_PauseButton_pressed():
	_pause_game()

func _on_restart_pressed():
	_on_unpause_pressed()
	emit_signal("reset_level")
