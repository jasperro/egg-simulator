extends Node

var current_instance
var current_level
var current_HUD
var current_egg

onready var HUD := preload("res://Assets/UI/HUD.tscn")
onready var egg := preload("res://Assets/Scenes/Egg.tscn")

func _load_level(path):
	current_egg = egg.instance()
	current_HUD = HUD.instance()
	current_level = path
	current_instance = load(path).instance()
	add_child(current_HUD)
	add_child(current_egg)
	add_child(current_instance)
	
func _reset_level():
	remove_child(current_egg)
	remove_child(current_HUD)
	remove_child(current_instance)
	_load_level(current_level)
