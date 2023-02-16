extends StaticBody3D

@export var platformcoloroverride := false
@export var platformcolor := Color(1,0,0,1)

func _enter_tree():
	if platformcoloroverride == true:
		var material = $MeshInstance.mesh.surface_get_material(0).duplicate()
		material.albedo_color = (platformcolor)
		$MeshInstance.mesh.surface_set_material(0,material)
	elif get_parent().name == "Platforms":
		$MeshInstance.mesh.surface_get_material(0).albedo_color = (get_parent().platformcolor)
