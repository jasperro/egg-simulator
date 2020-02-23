extends Area

const maxvel = 17.0
const minvel = 13.0

func _on_TrampolineCollider_area_entered(area):
	var egg = area.get_parent()
	var vel = egg.get_linear_velocity().y * -1.1
	if vel > maxvel:
		vel = maxvel
	elif vel < minvel:
		vel = minvel
	egg.set_linear_velocity(get_global_transform().basis * Vector3(0,vel,0))
	$'../AnimationPlayer'.play("trampoline")
