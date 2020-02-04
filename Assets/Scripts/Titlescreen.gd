extends Node

func _ready():
	get_node("./StartButton2").grab_focus()

func _on_StartButton_button_down():
	get_node("./CenterContainer/Loading").show()
	#get_node("").hide()
	get_node("./StartButton").margin_top = -999
	get_node("./StartButton").margin_bottom = -999
	get_node("./StartButton").margin_left = -999
	get_node("./StartButton").margin_right = -999
	get_node("./QuitButton").margin_top = -999
	get_node("./QuitButton").margin_bottom = -999
	get_node("./QuitButton").margin_left = -999
	get_node("./QuitButton").margin_right = -999

func _on_StartButton_button_up():
	get_tree().change_scene("res://Scenes/level1.tscn")

func _on_StartButton2_button_up():
	get_tree().change_scene("res://Scenes/3D levels/3dtest.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
