extends Node3D


@onready var saveButton=$CanvasLayer/Control/Save
@onready var backButton=$CanvasLayer/Control/Back
@onready var statusBox=$CanvasLayer/Control/Status
@onready var nextButton=$CanvasLayer/Control/Next
@onready var inputBox=$CanvasLayer/Control/LineEdit

var currStage=0

var mapData={
	"floor":{
		
	},
	"walls":{
		
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
