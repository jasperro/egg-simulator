extends VBoxContainer

func _on_StartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://Assets/Scenes/World.tscn"))

func _on_SettingsButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://Assets/UI/SettingsMenu.tscn"))

func _on_ExitButton_pressed():
	get_tree().quit()
