extends Node3D

var current_instance
var current_level
var current_HUD
var current_egg

@onready var HUD := preload("res://Assets/UI/HUD.tscn")
@onready var egg := preload("res://Assets/Scenes/Egg.tscn")

func _load_level(path):
	current_egg = egg.instantiate()
	current_HUD = HUD.instantiate()
	current_level = path
	current_instance = load(path).instantiate()
	add_child(current_HUD)
	add_child(current_egg)
	add_child(current_instance)
	current_egg.global_transform = current_instance.get_node("Start").global_transform
	
func _reset_level():
	remove_child(current_egg)
	remove_child(current_HUD)
	remove_child(current_instance)
	_load_level(current_level)
