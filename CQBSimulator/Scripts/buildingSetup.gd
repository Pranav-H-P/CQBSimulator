extends Node3D


@onready var saveButton=$CanvasLayer/Control/Save
@onready var backButton=$CanvasLayer/Control/Back
@onready var statusBox=$CanvasLayer/Control/Status
@onready var nextButton=$CanvasLayer/Control/Next
@onready var inputBox=$CanvasLayer/Control/LineEdit
@onready var camera=$Camera3D

@export var camMoveSpeed=10

var setMouse=false

var currStage=0

var mapData={
	"foundation":{
		
	},
	"innerWalls":{
		
	},
	"doors":{
		
	},
	"opStart":{
		
	},
	"enemy":{
		
	},
	"cover":{
		
	}
}

var stages={
	0:"Define Foundaton and Outer Walls",
	1:"Define Inner Walls",
	2:"Define Doors",
	3:"Define Operator Start Location",
	4:"Define Potential Enemy Locations",
	5:"Define Cover Locations/Obstacles",
	6:"Save And Quit"
}



func _ready():
	inputBox.visible=false

func _input(event):
	if event.is_action_pressed("leftClick"):
		shoot_ray()
	if event.is_action_pressed("rightClick"):
		pass


func _physics_process(delta):
	var input_dir = Input.get_vector("a", "d", "w", "s")
	
	if Input.is_action_just_released("zoomIn"):
		camera.global_position.y-=delta*camMoveSpeed*3
	if Input.is_action_just_released("zoomOut"):
		camera.global_position.y+=delta*camMoveSpeed*3
	
	
	camera.global_position.x+=delta*camMoveSpeed*input_dir.x
	camera.global_position.z+=delta*camMoveSpeed*input_dir.y
	

func shoot_ray():
	var mouse_pos=camera.get_viewport().get_mouse_position()
	var ray_length=1000
	var from = camera.project_ray_origin(mouse_pos)
	var to=from+camera.project_ray_normal(mouse_pos)*ray_length
	
	var space=camera.get_world_3d().direct_space_state
	var ray_query=PhysicsRayQueryParameters3D.new()
	ray_query.from=from
	ray_query.to=to
	var raycast_result=space.intersect_ray(ray_query)
	
	print(raycast_result)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	statusBox.text=stages[currStage]
	
	if currStage!=6:
		inputBox.visible=false
		nextButton.visible=true
		saveButton.visible=false
	else:
		inputBox.visible=true
		nextButton.visible=false
		saveButton.visible=true
	
	if currStage==0:
		backButton.visible=false
	else:
		backButton.visible=true


func _on_save_pressed():
	var mapName=inputBox.text
	if len(mapName)!=0:
		GLOBALS.appendMapData(mapName,mapData)
		
		get_tree().change_scene_to_file("res://Ui/MainMenu.tscn")


func _on_next_pressed():
	currStage+=1


func _on_back_pressed():
	currStage-=1
