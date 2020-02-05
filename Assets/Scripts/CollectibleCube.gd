extends Area

signal update_collect

func _on_Collectible_area_entered(area):
	get_node("/root/Global/Vars").collected += 1
	emit_signal("update_collect")
	queue_free()
	
func _ready():
	get_node("/root/Global/Vars").collectibles += 1
	connect("update_collect", get_tree().get_nodes_in_group(
	"HUD")[0].get_node("CollectionCounter"), "_update_collect")
	emit_signal("update_collect")
