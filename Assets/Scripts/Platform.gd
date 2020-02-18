extends StaticBody

export var platformcoloroverride = false
export(Color) var platformcolor = "#ff0000"

func _enter_tree():
	if platformcoloroverride == true:
		var material = $MeshInstance.get_surface_material(0).duplicate()
		material.set_albedo(platformcolor)
		$MeshInstance.set_surface_material(0,material)
	elif get_parent().name == "Platforms":
		$MeshInstance.get_surface_material(0).set_albedo(get_parent().platformcolor)
