extends Control

func _on_BackButton_pressed():
	get_tree().change_scene_to(load("res://Assets/UI/MainMenu.tscn"))
	get_tree().get_root().remove_child(get_node("."))

const SETTINGS_PATH = "user://settings.cfg"
var _config_file = ConfigFile.new()

var _default_settings = {
	"Video": {
		"Vsync": ProjectSettings.get_setting("display/window/vsync/use_vsync"),
		"BackgroundColor": ProjectSettings.get_setting("rendering/environment/default_clear_color")
	},
	"Control": {
		"TouchControlMode": true
		}
	}
var _settings = _default_settings

func _ready():
	_load_settings()
	
func _get_config_value(section, option):
	var value
	value = _config_file.get_value(section, option)
	if value == null:
		return _default_settings[section][option]
	else:
		return value

func _load_settings():
	var loaderror = _config_file.load(SETTINGS_PATH)
	if loaderror != OK:
		print("No config file available")
	for button in get_tree().get_nodes_in_group("Buttons"):
		if button is CheckButton:
			button.connect("toggled", self, "_on_" + button.name + "_toggled", [button])
		elif button is OptionButton:
			button.connect("item_selected", self, "_on_" + button.name + "_item_selected", [button])
		match button.name:
			"Vsync":
				button.set_pressed(_get_config_value("Video","Vsync"))
			"TouchControlMode":
				button.set_pressed(_get_config_value("Control","TouchControlMode"))

func _save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])
			_config_file.save(SETTINGS_PATH)

func _on_SaveButton_pressed():
	_save_settings()

# Button signal methods
func _on_Vsync_toggled(button_pressed, _button):
	_settings["Video"]["Vsync"] = button_pressed

func _on_TouchControlMode_toggled(button_pressed, _button):
	_settings["Control"]["TouchControlMode"] = button_pressed
