extends VBoxContainer

func _on_StartButton_pressed():
	get_tree().change_scene("res://Assets/Scenes/World.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Assets/UI/SettingsMenu.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
