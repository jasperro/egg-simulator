extends PopupPanel

onready var globalvars = get_node("/root/Global/Vars")
onready var world = get_node("/root/World")

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

# Opslaan van leveldata
	var file = File.new()
	if !file.file_exists("user://stats.json"):
		file.open("user://stats.json", File.WRITE)
		file.store_line("{}")
		file.close()
	file.open("user://stats.json", File.READ_WRITE)
	var statsdata = parse_json(file.get_as_text())
	var current_level = world.current_level.replace("res://Assets/Scenes/Levels/", "")
	
	# Sla tijd aan in json als deze er nog niet is
	if !statsdata.has(current_level):
		statsdata[current_level] = {"time":0}
		statsdata[current_level]["time"] = (
		$"../TimerCounter".leveltime)
	
	# Sla tijd op als deze korter is
	elif ($"../TimerCounter".leveltime < (
		statsdata[current_level]["time"])):
		$Items/Label.set_text(tr("i18n_newhigh"))
		statsdata[current_level]["time"] = (
		$"../TimerCounter".leveltime)
		
	file.store_line(JSON.print(statsdata))
	file.close()

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
