extends Camera3D

@export var speed=10
var setMouse=false

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("leftClick"):
		shoot_ray()
	if event.is_action_pressed("rightClick"):
		pass
	

func _physics_process(delta):
	var input_dir = Input.get_vector("a", "d", "w", "s")
	
	if Input.is_action_just_released("zoomIn"):
		global_position.y-=delta*speed*3
	if Input.is_action_just_released("zoomOut"):
		global_position.y+=delta*speed*3
	
	
	global_position.x+=delta*speed*input_dir.x
	global_position.z+=delta*speed*input_dir.y
	

func shoot_ray():
	var mouse_pos=get_viewport().get_mouse_position()
	var ray_length=1000
	var from = project_ray_origin(mouse_pos)
	var to=from+project_ray_normal(mouse_pos)*ray_length
	
	var space=get_world_3d().direct_space_state
	var ray_query=PhysicsRayQueryParameters3D.new()
	ray_query.from=from
	ray_query.to=to
	var raycast_result=space.intersect_ray(ray_query)
	
	print(raycast_result)
