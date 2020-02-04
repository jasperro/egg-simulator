extends Area

signal update_collect

func _on_Collectible_area_entered(area):
	connect("update_collect", get_tree().get_nodes_in_group(
	"HUD")[0].get_node("CollectionCounter"), "_update_collect")
	get_node("/root/Global/Vars").collected += 1
	emit_signal("update_collect")
	queue_free()
	
func _enter_tree():
	get_node("/root/Global/Vars").collectibles += 1