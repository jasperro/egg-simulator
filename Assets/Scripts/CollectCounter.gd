extends Label

var collectedgrammar = " Items"

func _enter_tree():
	_update_collect()

func _update_collect():
	if get_node("/root/Global/Vars").collected == 1:
		collectedgrammar = " Item"
	else:
		collectedgrammar = " Items"
	set_text("Collected " + str(get_node("/root/Global/Vars").collected)
	+ collectedgrammar + " of " + str(get_node("/root/Global/Vars").collectibles))