extends Control

var world
var levels
onready var levelcontainer_ps=preload("res://Assets/UI/LevelContainer.tscn")

func _ready():
	world = load("res://Assets/Scenes/World.tscn")
	var file = File.new()
	file.open("res://Assets/Data/levels.json", File.READ)
	levels = parse_json(file.get_as_text())
	var iter = 0
	for key in levels["categories"]:
		iter+=1
		var button = Button.new()
		button.set_text(str(iter) + " " + tr(levels["categories"][key]["description"]))
		levels["categories"][key]["button"] = button
		$CategoryContainer/CategorySelector.add_child(button)
		button.connect("pressed", self, "_category_button_pressed", [button])
		
func _category_button_pressed(button):
	$CategoryContainer.visible = false
	var iter = 0
	var levelcontainer = levelcontainer_ps.instance()
	add_child(levelcontainer)
	var levelselector = $LevelContainer/LevelSelector
	for i in levels["categories"]:
		if levels["categories"][i]["button"] == button:
			if levels["categories"][i].has("levels"):
				for e in levels["categories"][i]["levels"]:
					iter+=1
					var newbutton = Button.new()
					newbutton.set_text(str(e) + " - " + str(iter))
					levelselector.add_child(newbutton)
					newbutton.connect("pressed", self, "_level_button_pressed", [levels["categories"][i]["levelroot"] + e + ".tscn"])

func _level_button_pressed(scene):
	_load_level(scene)

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
