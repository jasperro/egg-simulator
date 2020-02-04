extends RigidBody

# Camera en rotatiebron, zodat de camera niet apart berekend hoeft te worden
var camera
var rotator_node

# Sensitiviteiten
var MOUSE_SENSITIVITY = 1.0
var JOYPAD_SENSITIVITY = 1.0
const JOYPAD_DEADZONE = 0.15

func _ready():
	
	# Camera en rotatiebron instellen
	camera = get_node("Rotator/Camera")
	rotator_node = get_node("Rotator")
	
	# Muis onzichtbaar maken
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	
	# Herhaal deze functies
		process_input(delta)
		process_view_input(delta)
	# Automatische bewegingsmodus:
	#	add_central_force(-camera.get_global_transform().basis.z * 100)

func process_input(delta):

	# Cameratransformatie verkrijgen om camerarichting te bepalen
	var cam_xform = camera.get_global_transform()
	
	# Vector voor alle muisbewegingen/joystickinput
	var input_movement_vector = Vector2()
	
	# Bewegingsvector toetsenbord
	if Input.is_action_pressed("movement_forward"):
		add_central_force(-camera.get_global_transform().basis.z * 100)
	if Input.is_action_pressed("movement_back"):
		add_central_force(camera.get_global_transform().basis.z * 100)
	if Input.is_action_pressed("movement_left"):
		add_central_force(-camera.get_global_transform().basis.x * 100)
	if Input.is_action_pressed("movement_right"):
		add_central_force(camera.get_global_transform().basis.x * 100)
	
	# Check voor joysticks
	if Input.get_connected_joypads().size() > 0:
		
		var joypad_vec = Vector2(0, 0)
		
		if OS.get_name() == "Windows":
			joypad_vec = Vector2(Input.get_joy_axis(0, 0), -Input.get_joy_axis(0, 1))
		elif OS.get_name() == "X11":
			joypad_vec = Vector2(Input.get_joy_axis(0, 1), Input.get_joy_axis(0, 2))
		elif OS.get_name() == "OSX":
			joypad_vec = Vector2(Input.get_joy_axis(0, 1), Input.get_joy_axis(0, 2))
		
		# Dode zones
		# (http://www.third-helix.com/2013/04/12/doing-thumbstick-dead-zones-right.html)
		if joypad_vec.length() < JOYPAD_DEADZONE:
			joypad_vec = Vector2(0, 0)
		else:
			joypad_vec = joypad_vec.normalized() * ((joypad_vec.length() - JOYPAD_DEADZONE) / (1 - JOYPAD_DEADZONE))
		
		# Joystickbeweging incorporeren
		input_movement_vector += joypad_vec
	
	# Normalize the input movement vector so we cannot move faster if we have
	# keyboard movement and joypad movement at the same time.
	# Hoe werkt dit?
	
	input_movement_vector = input_movement_vector.normalized()
	
	# Add the camera's local vectors based on what direction we are heading towards.
	# NOTE: because the camera is rotated by -180 degrees
	# all of the directional vectors are the opposite in comparison to our KinematicBody.
	# (The camera's local Z axis actually points backwards while our KinematicBody points forwards)
	# To get around this, we flip the camera's directional vectors so they point in the same direction
	# dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
	# dir += cam_xform.basis.x.normalized() * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Capturing the mouse.
	# Because our pause menu assures the mouse is visible, all we need to do is
	# check if the mouse is visible, and if it is make it captured.
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func process_view_input(delta):
	
	# If our cursor is not captured, then we do NOT want to rotate
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	# Joypad rotation
	
	# Get the right joypad movement vector, if there is a joypad connected (otherwise joypad_vec will equal (0, 0))
	var joypad_vec = Vector2()
	if Input.get_connected_joypads().size() > 0:
		
		# For windows (Wired XBOX 360 controller)
		if OS.get_name() == "Windows":
			joypad_vec = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
		# For Linux (Wired XBOX 360 controller)
		elif OS.get_name() == "X11":
			joypad_vec = Vector2(Input.get_joy_axis(0, 3), Input.get_joy_axis(0, 4))
		# For Mac (Wired XBOX 360 controller). (I have no idea on it's axis, so we'll just use the same as Linux):
		elif OS.get_name() == "OSX":
			joypad_vec = Vector2(Input.get_joy_axis(0, 3), Input.get_joy_axis(0, 4))
		
		# Account for joypad dead zones.
		# Using the code provided in the article linked below:
		# (http://www.third-helix.com/2013/04/12/doing-thumbstick-dead-zones-right.html)
		if joypad_vec.length() < JOYPAD_DEADZONE:
			joypad_vec = Vector2(0, 0)
		else:
			joypad_vec = joypad_vec.normalized() * ((joypad_vec.length() - JOYPAD_DEADZONE) / (1 - JOYPAD_DEADZONE))
	
		# Rotate the camera holder (everything that needs to rotate on the X-axis) by the relative Y joypad motion.
		# NOTE: If you want your joystick inverted, then change "joypad_vec.y" to "-joypad_vec.y".
		rotator_node.rotate_x(deg2rad(joypad_vec.y * JOYPAD_SENSITIVITY))
		
		# Rotate the kinematic body on the Y axis by the relative X motion.
		# We also need to multiply it by -1 because we're wanting to turn in the same direction as
		# joystick motion in real life. If we physically move the joystick left, we want to turn to the left.
		rotate_y(deg2rad(joypad_vec.x * JOYPAD_SENSITIVITY * -1))
		
		# We need to clamp the rotator_node's rotation so we cannot rotate ourselves upside down
		# We need to do this every time we rotate so we cannot rotate upside down with mouse and/or joypad input
		var camera_rot = rotator_node.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotator_node.rotation_degrees = camera_rot
	# ----------------------------------


# Mouse based camera movement
func _input(event):
	
	# Make sure the event is a mouse motion event and that our cursor is locked.

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Mouse rotation.
		
		# Rotate the camera holder (everything that needs to rotate on the X-axis) by the relative Y mouse motion.
		var x_change_deg = event.relative.y * MOUSE_SENSITIVITY
		
		# Rotate the kinematic body on the Y axis by the relative X motion.
		# We also need to multiply it by -1 because we're wanting to turn in the same direction as
		# mouse motion in real life. If we physically move the mouse left, we want to turn to the left.
		var y_change_deg = event.relative.x * MOUSE_SENSITIVITY * -1

		# We need to clamp the rotator_node's rotation so we cannot rotate ourselves upside down
		# We need to do this every time we rotate so we cannot rotate upside down with mouse and/or joypad input
		#var curr_x_rot = rad2deg(rotation.x)
		#if x_change_deg > 0:
		#	x_change_deg = min(x_change_deg, 70 - curr_x_rot)
		#else:
		#	x_change_deg = max(x_change_deg, -70 - curr_x_rot)

		#rotator_node.rotate_x(deg2rad(x_change_deg))
		rotator_node.rotate_y(deg2rad(y_change_deg))