extends Node

var current_instance
var current_level

func _load_level(path):
	current_level = path
	current_instance = load(path).instance()
	add_child(current_instance)
	
func _reset_level():
	remove_child(current_instance)
	_load_level(current_level)
