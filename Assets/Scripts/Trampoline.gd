extends Area

func _on_TrampolineCollider_area_entered(area):
	area.get_parent().set_linear_velocity(get_global_transform().basis * Vector3(0,15,0))
