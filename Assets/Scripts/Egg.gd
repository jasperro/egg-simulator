extends RigidBody

# Camera en rotatiebron
onready var camera = get_node("Rotator/Camera")
onready var rotator_node = get_node("Rotator")

var splitegg
var last_hurrah := false
# Positie van ei in het begin, standaard y=50
onready var _initial_position = get_global_transform()
onready var hud_node = get_tree().get_nodes_in_group("HUD")[0]

# Sensitiviteiten
export var MOUSE_SENSITIVITY = 1.0
export var TOUCH_SENSITIVITY = 0.7
export var KB_VECTOR_MODIFIER = 80
onready var timercounter = get_tree().get_nodes_in_group("HUD")[0].get_node("TimerCounter")
onready var win_popup = get_tree().get_nodes_in_group("HUD")[0].get_node("win_popup")
onready var world = get_node("/root/World")
onready var globalvars = get_node("/root/Global/Vars")

signal reset_level
signal reset_timer
signal level_won

func _ready():
	
	# Muis onzichtbaar maken
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	connect("reset_level", get_node("/root/World"), "_reset_level")
	connect("reset_timer", timercounter, "_reset")
	connect("level_won", win_popup, "_level_won")

func _physics_process(delta):
	
	# Herhaal deze functies
	process_input(delta)
	if !last_hurrah:
		if translation.y < -45:
			# Start last_hurrah
			timercounter.stop = true
			last_hurrah = true
			$EggWhole.visible = false
			$CollisionShape.disabled = true
			
			# Kapot ei genereren
			splitegg = load("res://Assets/Models/Scenes/SplitEgg.tscn").instance()
			$"..".add_child(splitegg)
			splitegg.set_transform(get_transform())
			splitegg.get_node("EggTop").set_linear_velocity(get_linear_velocity())
			splitegg.get_node("EggBottom").set_linear_velocity(get_linear_velocity())
			splitegg.get_node("EggTop").set_angular_velocity(get_angular_velocity()*0.2)
			splitegg.get_node("EggBottom").set_angular_velocity(get_angular_velocity()*0.3)
			splitegg.get_node("EggTop").set_angular_damp(0.1)
			splitegg.get_node("EggBottom").set_angular_damp(0.1)
			mode = RigidBody.MODE_STATIC
			
	elif last_hurrah:
		if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(1):
			_reset_level()

		
	# Automatische bewegingsmodus:
	#	add_central_force(-camera.get_global_transform().basis.z * 100)

func _reset_level():
	if splitegg != null:
		splitegg.queue_free()
	last_hurrah = false
	get_node("/root/Global/Vars").collected = 0
	get_node("/root/Global/Vars").collectibles = 0
	emit_signal("reset_level")

func process_input(_delta):

	# Vector voor alle muisbewegingen/joystickinput/accelerometer
	var input_movement_vector = Vector2()
	
	# Bewegingsvector toetsenbord & accelerometer
	if Input.get_accelerometer():
		add_central_force(camera.get_global_transform().basis.z * Vector3(0, 0, Input.get_accelerometer()[2]*40+200) + Vector3(Input.get_accelerometer()[0]*-30,0,0))

	if Input.is_action_pressed("movement_forward"):
		add_central_force(-camera.get_global_transform().basis.z * KB_VECTOR_MODIFIER)
	if Input.is_action_pressed("movement_back"):
		add_central_force(camera.get_global_transform().basis.z * KB_VECTOR_MODIFIER)
	if Input.is_action_pressed("movement_left"):
		add_central_force(-camera.get_global_transform().basis.x * KB_VECTOR_MODIFIER)
	if Input.is_action_pressed("movement_right"):
		add_central_force(camera.get_global_transform().basis.x * KB_VECTOR_MODIFIER)
		
	if Input.is_action_just_released("next_level"):
		globalvars.levelindex += 1
		if globalvars.levelindex > (globalvars.levels.size() - 1):
			pass
		else:
			world.current_level = (globalvars.levelroot + globalvars.levels[globalvars.levelindex])
			# Laad volgende level
			_reset_level()
	
	# Muis vastpakken
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _level_won():
	emit_signal("level_won")
# Muis camera
func _input(event):
	if event is InputEventScreenDrag:
		var y_change_deg = event.relative.x * TOUCH_SENSITIVITY * -1
		rotator_node.rotate_y(deg2rad(y_change_deg))
	elif event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var y_change_deg = event.relative.x * MOUSE_SENSITIVITY * -1
		rotator_node.rotate_y(deg2rad(y_change_deg))
