extends Label

var collectedgrammar = " Items"
var collected = 0
var collectibles = 0

func _update_collect():
	if get_node("/root/Global/Vars").collected == 1:
		collectedgrammar = " Item"
	else:
		collectedgrammar = " Items"
	set_text("Collected " + str(get_node("/root/Global/Vars").collected)
	+ collectedgrammar + " of " + str(get_node("/root/Global/Vars").collectibles))
	
	if get_node("/root/Global/Vars").collected == get_node("/root/Global/Vars").collectibles:
		set_text("Eggcelent!")
		# Winscherm?
