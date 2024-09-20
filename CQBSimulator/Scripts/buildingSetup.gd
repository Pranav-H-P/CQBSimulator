extends Node3D




@onready var saveButton=$CanvasLayer/Control/Save
@onready var statusBox=$CanvasLayer/Control/Status
@onready var nextButton=$CanvasLayer/Control/Next
@onready var inputBox=$CanvasLayer/Control/LineEdit
@onready var camera=$Camera3D

@export var camMoveSpeed=10

var foundationBox=preload("res://Nodes/FoundationBox.tscn")
var wallBox=preload("res://Nodes/InnerWall.tscn")
var coverBox=preload("res://Nodes/CoverBox.tscn")
var opStartPt=preload("res://Nodes/PlayerMarker.tscn")
var door=preload("res://Nodes/Door.tscn")
var enemyArea=preload("res://Nodes/EnemyMarker.tscn")

var objectBuffer=[]
var positionBuffer=[]

var draw=false
var startCoords
var currStage=0

var currObj
var currMousePos
var rotationAngle=0

var mapData={
	"foundation":{
			#"startCoords":startCoords,
			#"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]
	},
	"innerWalls":{
		#0:{#"startCoords":startCoords,
			#"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]
			#},
		#1:{#"startCoords":startCoords,
			#"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]
			#},
			
	},
	"doors":{
		
	},
	"opStart":{
		
	},
	"enemy":{
		#0:{#"startCoords":startCoords,
			#"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]
			#},
		#1:{#"startCoords":startCoords,
			#"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]
			#},
	},
	"cover":{
		#0:{#"startCoords":startCoords,
			#"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]
			#},
		#1:{#"startCoords":startCoords,
			#"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]
			#},
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
	
	if event.is_action_pressed("z"):
		
		if len(objectBuffer)!=0:
			draw=false
			if currStage==2 or currStage==3:
				draw=true
				
			if currStage==3:
				draw=true
				objectBuffer.pop_back()
			else:
				objectBuffer.back().queue_free()
				objectBuffer.pop_back()
			
			if currStage in [1,2,4,5]:
				positionBuffer.pop_back()
			
				
			
	
	if event.is_action_pressed("leftClick"):
		startCoords=get_point()
		
		
		if currStage==0 and len(objectBuffer)==0:
			draw=true
			currObj=foundationBox.instantiate()
			currObj.position.y=0.1
			
			currObj.position.x=startCoords[0]+0.5
			currObj.position.z=startCoords[1]+0.5
			
			add_child(currObj)
			objectBuffer.append(currObj)
		
		elif currStage==1:
			draw=true
			currObj=wallBox.instantiate()
			currObj.position.y=0.2
			
			currObj.position.x=startCoords[0]+0.5
			currObj.position.z=startCoords[1]+0.5
			
			add_child(currObj)
			objectBuffer.append(currObj)
		
		elif currStage==2:
			
			positionBuffer.append({"startCoords":startCoords,"rotation":currObj.rotation.y})
			objectBuffer.append(currObj)
			currObj=door.instantiate()
			currObj.freeze()
			add_child(currObj)
			
			
			
		elif currStage==3 and len(objectBuffer)==0:
			mapData["opStart"]={
				"startCoords":startCoords				
			}
			objectBuffer.append(currObj)
			draw=false
		
		elif currStage==4:
			draw=true
			currObj=enemyArea.instantiate()
			currObj.position.y=0.2
			
			currObj.position.x=startCoords[0]+0.5
			currObj.position.z=startCoords[1]+0.5
			
			add_child(currObj)
			objectBuffer.append(currObj)
		elif currStage==5:
			draw=true
			currObj=coverBox.instantiate()
			currObj.position.y=0.2
			
			currObj.position.x=startCoords[0]+0.5
			currObj.position.z=startCoords[1]+0.5
			
			add_child(currObj)
			objectBuffer.append(currObj)
		
	if event.is_action_released("leftClick"):
		
		
		if currStage==0 and draw==true:
			draw=false
			mapData["foundation"]={
				"startCoords":startCoords,
				"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z	]
				
			}
		
			
		elif (currStage in [1,4,5]) and draw==true:
			draw=false
			positionBuffer.append({"startCoords":startCoords,"size":[objectBuffer.back().scale.x,objectBuffer.back().scale.z]})
				
			
			
			
		
	


func _physics_process(delta):
	
	if draw:
		currMousePos=get_point()
		if currStage in [0,1,4,5]:
			
			objectBuffer.back().position.x=startCoords[0]+(objectBuffer.back().scale.x)/2
			objectBuffer.back().position.z=startCoords[1]+(objectBuffer.back().scale.z)/2
			objectBuffer.back().scale.x=abs(startCoords[0]+0.5-currMousePos[0])
			objectBuffer.back().scale.z=abs(startCoords[1]+0.5-currMousePos[1])
		
		elif currStage==2:
			currObj.position.x=currMousePos[0]
			currObj.position.z=currMousePos[1]
			if Input.is_action_just_pressed("r"):
		
				currObj.rotation.y=deg_to_rad(rotationAngle)
				rotationAngle=(rotationAngle+90)%360
		elif currStage==3:
			currObj.position.x=currMousePos[0]
			currObj.position.z=currMousePos[1]
			
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
	
	statusBox.text=stages[currStage]
	
	
	if currStage==0:
		inputBox.visible=false
		saveButton.visible=false
		
		if len(mapData["foundation"])!=0:
			nextButton.visible=true
		else:
			nextButton.visible=false
			
	elif currStage==1:
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
	var multiItemStage={1:"innerWalls",2:"doors",4:"enemy",5:"cover"}
	
	if (currStage in [1,2,4,5]):
		positionBuffer.pop_back()
		objectBuffer.back().queue_free()
		objectBuffer.pop_back()
		var count=0
		for i in positionBuffer:
			
			mapData[multiItemStage[currStage]][count]=i
			
			count+=1
	
	
	objectBuffer.clear()
	
	positionBuffer.clear()
	print(mapData)
	currStage+=1
	
	if currStage==2:
		currObj=door.instantiate()
		currObj.freeze()
		add_child(currObj)
		draw=true
	elif currStage==3:
		currObj=opStartPt.instantiate()
		currObj.position.y=2
		add_child(currObj)
		draw=true
