extends Label

var lifegrammar = " Lives"

func _physics_process(delta):
	if get_node("../../Player").get("lives") == 1:
		lifegrammar = " Life"
	else:
		lifegrammar = " Lives"
	#set_text(String(get_node("../../Player").get("lives")) + lifegrammar)
	pass
