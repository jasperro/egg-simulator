extends Control

func _on_StartButton_pressed():
	get_tree().change_scene_to(preload("res://Assets/UI/LevelSelector.tscn"))
	get_tree().get_root().remove_child(get_node("."))

func _on_SettingsButton_pressed():
	get_tree().change_scene_to(preload("res://Assets/UI/SettingsMenu.tscn"))
	get_tree().get_root().remove_child(get_node("."))

func _on_ExitButton_pressed():
	get_tree().quit()
