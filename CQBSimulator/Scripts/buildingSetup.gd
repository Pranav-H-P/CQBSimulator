extends Node3D




@onready var saveButton=$CanvasLayer/Control/Save
@onready var backButton=$CanvasLayer/Control/Back
@onready var statusBox=$CanvasLayer/Control/Status
@onready var nextButton=$CanvasLayer/Control/Next
@onready var inputBox=$CanvasLayer/Control/LineEdit
@onready var camera=$Camera3D

@export var camMoveSpeed=10

var foundationBox=preload("res://Nodes/FoundationBox.tscn")
var wallBox=preload("res://Nodes/InnerWall.tscn")
var coverBox=preload("res://Nodes/CoverBox.tscn")
var opStartPt=preload("res://Nodes/PlayerMarker.tscn")

var buffer=[]
var draw=false
var startCoords
var currStage=0

var currObj
var currMousePos

var placedObjs={
	0:[],
	1:[],
	2:[],
	3:[],
	4:[],
	5:[]
	
}

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

func clear_stage():
	
	for i in placedObjs[currStage-1]:
		i.queue_free()
	placedObjs[currStage-1].clear()
	
	if currStage==1:
		
		mapData['foundation'].clear()
		
	elif currStage==2:
		mapData['innerWalls'].clear()
		
	elif currStage==3:
		mapData['doors'].clear()
	elif currStage==4:
		mapData['opStart'].clear()
	elif currStage==5:
		mapData['enemy'].clear()
			
	elif currStage==6:
		mapData['cover'].clear()

func _input(event):
	
	if event.is_action_pressed("z"):
		if len(buffer)!=0:
			draw=false
			buffer.back().queue_free()
			buffer.pop_back()
			
	
	if event.is_action_pressed("leftClick"):
		startCoords=get_point()
		
		
		if currStage==0 and len(buffer)==0:
			draw=true
			currObj=foundationBox.instantiate()
			currObj.position.y=0
			
			currObj.position.x=startCoords[0]+0.5
			currObj.position.z=startCoords[1]+0.5
			
			add_child(currObj)
			buffer.append(currObj)
			
		
	if event.is_action_released("leftClick"):
		
		
		if currStage==0 and draw==true:
			draw=false
			mapData["foundation"]={
				"startCoords":startCoords,
				"size":[buffer.back().scale.x,buffer.back().scale.z	],
				
			}
			
			
		
	if event.is_action_pressed("rightClick"):
		pass


func _physics_process(delta):
	#print(mapData)
	if draw:
		currMousePos=get_point()
		buffer.back().position.x=startCoords[0]+(buffer.back().scale.x)/2
		buffer.back().position.z=startCoords[1]+(buffer.back().scale.z)/2
		buffer.back().scale.x=abs(startCoords[0]+0.5-currMousePos[0])
		buffer.back().scale.z=abs(startCoords[1]+0.5-currMousePos[1])
	
	var input_dir = Input.get_vector("a", "d", "w", "s")
	
	if Input.is_action_just_released("zoomIn"):
		camera.global_position.y-=delta*camMoveSpeed*3
	if Input.is_action_just_released("zoomOut"):
		camera.global_position.y+=delta*camMoveSpeed*3
	
	
	camera.global_position.x+=delta*camMoveSpeed*input_dir.x
	camera.global_position.z+=delta*camMoveSpeed*input_dir.y
	

func get_point():
	var mouse_pos=camera.get_viewport().get_mouse_position()
	var ray_length=1000
	var from = camera.project_ray_origin(mouse_pos)
	var to=from+camera.project_ray_normal(mouse_pos)*ray_length
	
	var space=camera.get_world_3d().direct_space_state
	var ray_query=PhysicsRayQueryParameters3D.new()
	ray_query.from=from
	ray_query.to=to
	var raycast_result=space.intersect_ray(ray_query)
	
	return [raycast_result["position"].x,raycast_result["position"].z]




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(mapData)
	statusBox.text=stages[currStage]
	
	
	if currStage==0:
		backButton.visible=false
		inputBox.visible=false
		saveButton.visible=false
		
		if len(mapData["foundation"])!=0:
			nextButton.visible=true
		else:
			nextButton.visible=false
			
	elif currStage==1:
		backButton.visible=true
		nextButton.visible=true
		
	elif currStage==2:
		nextButton.visible=true
		
	elif currStage==3:
		if len(mapData["opStart"])!=0:
			nextButton.visible=true
	elif currStage==4:
		nextButton.visible=true
	elif currStage==5:
		
		nextButton.visible=true
			
	elif currStage==6:
		inputBox.visible=true
		nextButton.visible=false
		saveButton.visible=true
		
	
	
	
	


func _on_save_pressed():
	var mapName=inputBox.text
	if len(mapName)!=0:
		GLOBALS.appendMapData(mapName,mapData)
		
		get_tree().change_scene_to_file("res://Ui/MainMenu.tscn")


func _on_next_pressed():
	
	
	for i in buffer:
		placedObjs[currStage].append(i)
	buffer.clear()
	currStage+=1

func _on_back_pressed():
	
	clear_stage()
	currStage-=1
