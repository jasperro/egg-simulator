extends Area

func _on_ConveyorCollider_area_entered(area):
	var egg = area.get_parent()
	egg.set_linear_velocity(get_global_transform().basis * Vector3(0,0,15))
