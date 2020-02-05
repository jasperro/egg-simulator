extends Label

func _physics_process(delta):
	set_text(str(Engine.get_frames_per_second())+" FPS")
	pass
