extends Control

var _language_indexes := {} # Dict voor taalcodes
onready var global := get_node("/root/Global")

func _on_BackButton_pressed():
	get_tree().change_scene_to(load("res://Assets/UI/MainMenu.tscn"))
	get_tree().get_root().remove_child(get_node("."))

func _on_SaveButton_pressed():
	global._save_settings()

func _ready():
	global._load_settings()
	_load_settings()

# Functie om waarde uit de settings te krijgen
func _get_config_value(section, option):
	return global._get_config_value(section, option)

# Anders dan global.load_settings die de settings laadt,
# stelt deze functie de knopwaarden in.
func _load_settings():
	for button in get_tree().get_nodes_in_group("Buttons"):
		# Check voor knoptypes
		if button is CheckButton:
			button.connect("toggled", self, "_on_" + button.name + "_toggled", [button])
		elif button is OptionButton:
			button.connect("item_selected", self, "_on_" + button.name + "_item_selected", [button])

		match button.name:
			"Vsync":
				button.set_pressed(_get_config_value("Video","Vsync"))
			"TouchControlMode":
				button.set_pressed(_get_config_value("Control","TouchControlMode"))
			"Language":
				button.add_item("Default")
				var language = _get_config_value("Other","Language")
				var iter = 1
				for l in TranslationServer.get_loaded_locales():
					_language_indexes[l] = iter
					iter+=1
					button.add_item(TranslationServer.get_locale_name(l))
				if language == "default":
					button.select(0)
				else:
					if language == "en":
						button.select(_language_indexes["en"])
					elif language == "nl":
						button.select(_language_indexes["nl"])

# Functies voor waardeverandering knoppen

func _on_Vsync_toggled(button_pressed, _button):
	global._settings["Video"]["Vsync"] = button_pressed

func _on_TouchControlMode_toggled(button_pressed, _button):
	global._settings["Control"]["TouchControlMode"] = button_pressed
	
func _on_Language_item_selected(id, _button):
	if id > 0:
		TranslationServer.set_locale(TranslationServer.get_loaded_locales()[id-1])
		global._settings["Other"]["Language"] = TranslationServer.get_locale()
	else:
		TranslationServer.set_locale(OS.get_locale())
		global._settings["Other"]["Language"] = "default"
