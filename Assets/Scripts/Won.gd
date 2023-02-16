extends Control

@onready var world := preload("res://Assets/Scenes/World.tscn")

func _load_level(scene):
	var level = get_node(".")
	var next_level = world.instantiate()
	get_parent().add_child(next_level)
	next_level._load_level(scene)
	get_parent().remove_child(level)
	level.call_deferred("free")

func _on_Next_pressed():
	_load_level("res://Assets/Scenes/Levels/Level2.tscn")
