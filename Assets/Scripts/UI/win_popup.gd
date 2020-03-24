extends PopupPanel

onready var globalvars = get_node("/root/Global/Vars")

func _level_won():
	set_exclusive(true)
	popup()
	get_tree().set_pause(true)
	if globalvars.levelindex >= (globalvars.levels.size() - 1):
		$Items/ButtonNext.hide()
	else:
		$Items/ButtonNext.show()
	set_anchors_and_margins_preset(Control.PRESET_CENTER)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"../CollectionCounter".visible = false
	$"../TimerCounter".visible = false
	$Items/Time.set_text(tr("i18n_time") + ": " + str(stepify((float($"../TimerCounter".leveltime)/1000),0.001)) + "s")

func _on_ButtonNext_pressed():
	set_exclusive(false)
	hide()
	get_tree().set_pause(false)
	$"/root/World".current_egg.get_node("Egg")._next_level()

func _on_ButtonExit_pressed():
	globalvars.collectibles = 0
	globalvars.collected = 0
	set_exclusive(false)
	hide()
	get_tree().set_pause(false)
	get_tree().get_root().add_child(load("res://Assets/UI/MainMenu.tscn").instance())
	get_tree().get_root().remove_child(get_node("/root/World"))
