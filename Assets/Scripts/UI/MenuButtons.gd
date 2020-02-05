extends VBoxContainer

func _enter_tree():
	$StartButton.connect("pressed", self, "_on_StartButton_pressed")
	$SettingsButton.connect("pressed", self, "_on_SettingsButton_pressed")
	$ExitButton.connect("pressed", self, "_on_ExitButton_pressed")
	
func _on_StartButton_pressed():
	get_tree().change_scene_to(load("res://Assets/UI/LevelSelector.tscn"))

func _on_SettingsButton_pressed():
	get_tree().change_scene_to(load("res://Assets/UI/SettingsMenu.tscn"))

func _on_ExitButton_pressed():
	get_tree().quit()
