extends Node

var current_instance
var current_level

func _ready():
	# Laad level (Scene Instancing),
	# is het slim om deze code hier te zetten?
	# Of beter een method met connect()?
	#_load_level("res://Assets/Scenes/Levels/Level1.tscn")
	pass


func _load_level(path):
	current_level = path
	current_instance = load(path).instance()
	add_child(current_instance)
	connect("update_collect", get_tree().get_nodes_in_group(
	"HUD")[0].get_node("CollectionCounter"), "_update_collect")
	emit_signal("update_collect")
	
	
func _reset_level():
	remove_child(current_instance)
	_load_level(current_level)
	_ready()
