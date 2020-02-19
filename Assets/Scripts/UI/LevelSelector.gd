extends Control

var world
var leveldata
onready var levelcontainer_ps=preload("res://Assets/UI/LevelContainer.tscn")
onready var global=get_node("/root/Global")

func _ready():
	world = load("res://Assets/Scenes/World.tscn")
	var file = File.new()
	file.open("res://Assets/Data/levels.json", File.READ)
	leveldata = parse_json(file.get_as_text())
	var iter = 0
	for key in leveldata["categories"]:
		iter+=1
		var button = Button.new()
		button.set_text(str(iter) + " " + tr(leveldata["categories"][key]["description"]))
		leveldata["categories"][key]["button"] = button
		$CategoryContainer/CategorySelector.add_child(button)
		button.connect("pressed", self, "_category_button_pressed", [button])
		
func _category_button_pressed(button):
	$CategoryContainer.visible = false
	var iter = 0
	var levelcontainer = levelcontainer_ps.instance()
	add_child(levelcontainer)
	var LevelSelector = $LevelContainer/LevelSelector
	
	for i in leveldata["categories"]:
		if leveldata["categories"][i]["button"] == button:
			if leveldata["categories"][i].has("levelroot"):
				var levels = global._list_files_in_directory(leveldata["categories"][i]["levelroot"])
				levels.sort_custom(self, "_alphasort")
				for e in levels:
					iter+=1
					var newbutton = Button.new()
					newbutton.set_text(str(e) + " - " + str(iter))
					LevelSelector.add_child(newbutton)
					newbutton.connect("pressed", self, "_level_button_pressed", [leveldata["categories"][i]["levelroot"] + e])

func _level_button_pressed(scene):
	_load_level(scene)

func _alphasort(a, b):
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return a < b

func _on_BackButton_pressed():
	if $LevelContainer:
		$CategoryContainer.visible = true
		remove_child($LevelContainer)
	else:
		get_tree().change_scene_to(load("res://Assets/UI/MainMenu.tscn"))
		get_tree().get_root().remove_child(get_node("."))


func _load_level(scene):
	var level = get_node(".")
	var next_level = world.instance()
	get_parent().add_child(next_level)
	next_level._load_level(scene)
	get_parent().remove_child(level)
	level.call_deferred("free")
