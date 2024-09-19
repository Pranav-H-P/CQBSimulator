extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	resume()
	visible=false

func pause():
	get_tree().paused=true
	visible=true
	
	
func resume():
	get_tree().paused=false
	visible=false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
	elif Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_pressed():
	resume()
	
func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()
