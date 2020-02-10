extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var ball

func _enter_tree():
	set_as_toplevel(true)
	ball = get_parent()

func _physics_process(_delta):
	set_global_transform(Transform(get_global_transform().basis,ball.get_global_transform().origin))
