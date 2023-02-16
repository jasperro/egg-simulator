extends Node

var _default_settings := {
	"Video": {
		"Vsync": ProjectSettings.get_setting("display/window/vsync/use_vsync"),
		"BackgroundColor": ProjectSettings.get_setting("rendering/environment/default_clear_color")
	},
	"Control": {
		"TouchControlMode": true
	},
	"Other": {
		"Language": "default"
	}
}
var _settings = _default_settings
var _config_file := ConfigFile.new()
const SETTINGS_PATH := "user://settings.cfg"
@onready var globalvars := $Vars

func _ready():
	_load_settings()
	if _get_config_value("Other","Language") != "default":
		TranslationServer.set_locale(_get_config_value("Other","Language"))
	else:
		TranslationServer.set_locale(OS.get_locale())
		
func _list_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files
	
func _get_config_value(section, option):
	var value
	value = _config_file.get_value(section, option)
	if value == null:
		value = _default_settings[section][option]
	_settings[section][option] = value
	return value

func _load_settings():
	var loaderror = _config_file.load(SETTINGS_PATH)
	if loaderror != OK:
		print("No config file available")

func _save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])
			_config_file.save(SETTINGS_PATH)
