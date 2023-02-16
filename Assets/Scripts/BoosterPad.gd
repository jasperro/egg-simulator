extends Area3D

const VEL = 200.0

func _on_BoosterPad_area_entered(area):
	var egg = area.get_parent()
	#var vel = Vector2(egg.get_linear_velocity().x, egg.get_linear_velocity().z)
	print(egg.get_linear_velocity())
	egg.set_linear_velocity(get_global_transform().basis * Vector3(1,-30,30))
	#egg.set_linear_velocity(get_global_transform().basis * Vector3(1,0,-1))
