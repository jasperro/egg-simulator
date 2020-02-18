extends RigidBody

# Camera en rotatiebron, zodat de camera niet apart berekend hoeft te worden
var camera
var rotator_node
var splitegg
# Variabele wanneer ei gebroken is
var last_hurrah = false
# Positie van ei in het begin, standaard y=50
var _initial_position
var hud_node

# Sensitiviteiten
export var MOUSE_SENSITIVITY = 1.0
export var TOUCH_SENSITIVITY = 0.7

signal reset_level

func _ready():
	
	# Camera en rotatiebron instellen
	camera = get_node("Rotator/Camera")
	rotator_node = get_node("Rotator")
	
	# Muis onzichtbaar maken
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_initial_position = get_global_transform()
	hud_node = get_tree().get_nodes_in_group("HUD")[0]

func _enter_tree():
	connect("reset_level", get_node("/root/World"), "_reset_level")

func _physics_process(delta):
	
	# Herhaal deze functies
	process_input(delta)
	if !last_hurrah:
		if translation.y < -45:
			last_hurrah = true
			$EggWhole.visible = false
			$CollisionShape.disabled = true
			splitegg = load("res://Assets/Models/Scenes/SplitEgg.tscn").instance()
			get_node("..").add_child(splitegg)
			splitegg.set_transform(get_transform())
			splitegg.get_node("EggTop").set_linear_velocity(get_linear_velocity())
			splitegg.get_node("EggBottom").set_linear_velocity(get_linear_velocity())
			splitegg.get_node("EggTop").set_angular_velocity(get_angular_velocity()*0.2)
			splitegg.get_node("EggBottom").set_angular_velocity(get_angular_velocity()*0.3)
			splitegg.get_node("EggTop").set_angular_damp(0.1)
			splitegg.get_node("EggBottom").set_angular_damp(0.1)
			mode = RigidBody.MODE_STATIC
			
	elif last_hurrah:
		if Input.is_action_pressed("ui_accept"):
			set_global_transform(_initial_position)
			sleeping = true
			$EggWhole.visible = true
			mode = RigidBody.MODE_RIGID
			$CollisionShape.disabled = false
			last_hurrah = false
			get_node("/root/Global/Vars").collected = 0
			get_node("/root/Global/Vars").collectibles = 0
			emit_signal("reset_level")
			#yield(get_tree().create_timer(5.0), "timeout")
			splitegg.queue_free()
		
	# Automatische bewegingsmodus:
	#	add_central_force(-camera.get_global_transform().basis.z * 100)

func process_input(_delta):

	# Vector voor alle muisbewegingen/joystickinput/accelerometer
	var input_movement_vector = Vector2()
	
	# Bewegingsvector toetsenbord & accelerometer
	if Input.get_accelerometer():
		add_central_force(camera.get_global_transform().basis.z * Vector3(0, 0, Input.get_accelerometer()[2]*40+200) + Vector3(Input.get_accelerometer()[0]*-30,0,0))

	if Input.is_action_pressed("movement_forward"):
		add_central_force(-camera.get_global_transform().basis.z * 100)
	if Input.is_action_pressed("movement_back"):
		add_central_force(camera.get_global_transform().basis.z * 100)
	if Input.is_action_pressed("movement_left"):
		add_central_force(-camera.get_global_transform().basis.x * 100)
	if Input.is_action_pressed("movement_right"):
		add_central_force(camera.get_global_transform().basis.x * 100)
	
	# Muis vastpakken
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Muis camera
func _input(event):
	if event is InputEventScreenDrag:
		var y_change_deg = event.relative.x * TOUCH_SENSITIVITY * -1
		rotator_node.rotate_y(deg2rad(y_change_deg))
	elif event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var y_change_deg = event.relative.x * MOUSE_SENSITIVITY * -1
		rotator_node.rotate_y(deg2rad(y_change_deg))
