extends Control

var world

func _ready():
	world = load("res://Assets/Scenes/World.tscn")

func _load_level(scene):
	var level = get_node(".")
	var next_level = world.instance()
	get_parent().add_child(next_level)
	next_level._load_level(scene)
	get_parent().remove_child(level)
	level.call_deferred("free")

func _on_1_pressed():
	_load_level("res://Assets/Scenes/Levels/Level1.tscn")

func _on_2_pressed():
	_load_level("res://Assets/Scenes/Levels/Level2.tscn")


func _on_3_pressed():
	pass # Replace with function body.


func _on_4_pressed():
	pass # Replace with function body.


func _on_5_pressed():
	pass # Replace with function body.


func _on_Test_pressed():
	pass # Replace with function body.
