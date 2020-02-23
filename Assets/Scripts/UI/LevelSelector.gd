extends Control

var world
var leveldata
var levelroot
var levels

onready var levelcontainer_ps := preload("res://Assets/UI/LevelContainer.tscn")
onready var global := get_node("/root/Global")
onready var globalvars := get_node("/root/Global/Vars")

# Sorteer array op alfabet, beter als globale functie?
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

func _ready():
	# Laad wereld-scene
	world = load("res://Assets/Scenes/World.tscn")
	
	# Open bestand met levelcategoriën
	var file = File.new()
	file.open("res://Assets/Data/levels.json", File.READ)
	leveldata = parse_json(file.get_as_text())
	var iter = 0
	
	# Knoppen toevoegen voor levelcategoriën
	for key in leveldata["categories"]:
		iter+=1
		var button = Button.new()
		button.set_text(str(iter) + " " + tr(leveldata["categories"][key]["description"]))
		leveldata["categories"][key]["button"] = button
		$CategoryContainer/CategorySelector.add_child(button)
		button.connect("pressed", self, "_category_button_pressed", [button])
		
# Open levelselector
func _category_button_pressed(button):
	$CategoryContainer.visible = false
	var iter = 0
	var levelcontainer = levelcontainer_ps.instance()
	add_child(levelcontainer)
	var LevelSelector = $LevelContainer/LevelSelector
	
	for i in leveldata["categories"]:
		if leveldata["categories"][i]["button"] == button:
			if leveldata["categories"][i].has("levelroot"):
				levelroot = leveldata["categories"][i]["levelroot"]
				levels = global._list_files_in_directory(leveldata["categories"][i]["levelroot"])
				levels.sort_custom(self, "_alphasort")
				for e in levels:
					iter+=1
					var newbutton = Button.new()
					newbutton.set_text(str(e) + " - " + str(iter))
					LevelSelector.add_child(newbutton)
					newbutton.connect("pressed", self, "_level_button_pressed", [leveldata["categories"][i]["levelroot"] + e, iter - 1])

# Laad level
func _level_button_pressed(scene, iter):
	globalvars.levelroot = levelroot
	globalvars.levelindex = iter
	globalvars.levels = levels
	_load_level(scene)

func _load_level(scene):
	var level = get_node(".")
	var next_level = world.instance()
	get_parent().add_child(next_level)
	next_level._load_level(scene)
	get_parent().remove_child(level)
	level.call_deferred("free")
