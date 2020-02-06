extends Control

func _on_BackButton_pressed():
	get_tree().change_scene_to(load("res://Assets/UI/MainMenu.tscn"))
	get_tree().get_root().remove_child(get_node("."))
