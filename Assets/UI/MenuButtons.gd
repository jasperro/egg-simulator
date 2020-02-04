extends VBoxContainer

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/testlevel.tscn")


func _on_SettingsButton_pressed():
	pass # Open SettingsMenu scene


func _on_ExitButton_pressed():
	pass # Exit the game
