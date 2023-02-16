extends Area3D

signal update_collect

func _on_Collectible_area_entered(_area):
	get_node("/root/Global/Vars").collected += 1
	$AnimationPlayer.play("collect")
	emit_signal("update_collect")
	$AnimationPlayer.animation_finished.connect(self._do_anim_finished.bind("collect"))

func _do_anim_finished(__,___):
	queue_free()
	
func _enter_tree():
	get_node("/root/Global/Vars").collectibles += 1
	update_collect.connect(get_tree().get_nodes_in_group(
	"HUD")[0].get_node("CollectionCounter")._update_collect)
	emit_signal("update_collect")
