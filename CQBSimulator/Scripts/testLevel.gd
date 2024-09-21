extends Node3D

@onready var uiTab=$LevelUI/UITab
@onready var uiAnim=$LevelUI/UITab/AnimationPlayer
@onready var player=$Player

var door=preload("res://Nodes/Door.tscn")
var genericCube=preload("res://Nodes/GenericCube.tscn")

var wallHeight=7
var coverHeight=1.5

var levelData
var mapData

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#uiTab.visible=true
	
	levelData=GLOBALS.getCurrLevelData()
	mapData=levelData["MapData"]
	
	
	var outerWall1 = genericCube.instantiate()
	var outerWall2 = genericCube.instantiate()
	var outerWall3 = genericCube.instantiate()
	var outerWall4 = genericCube.instantiate()
	#var ceiling = genericCube.instantiate()
	
	
	add_child(outerWall1)
	add_child(outerWall2)
	add_child(outerWall3)
	add_child(outerWall4)
	#add_child(ceiling)
	
	var foundationPos=mapData["foundation"]["startCoords"]
	var foundationSize=mapData["foundation"]["size"]
		
	var outerWallPositions=[
		[foundationPos[0],foundationPos[1]],
		[foundationPos[0],foundationPos[1]],
		[foundationPos[0]+foundationSize[0],foundationPos[1]],
		[foundationPos[0],foundationPos[1]+foundationSize[1]]
	]
	var outerWallSizes=[
		[0.1,foundationSize[1]],
		[foundationSize[0],0.1],
		[0.1,foundationSize[1]],
		[foundationSize[0],0.1]
	]
	
	
	outerWall1.place(outerWallPositions[0],0,outerWallSizes[0],wallHeight)
	outerWall2.place(outerWallPositions[1],0,outerWallSizes[1],wallHeight)
	outerWall3.place(outerWallPositions[2],0,outerWallSizes[2],wallHeight)
	outerWall4.place(outerWallPositions[3],0,outerWallSizes[3],wallHeight)
	
	#ceiling.place(foundationPos,wallHeight,foundationSize,1)
	
	var doorData=mapData["doors"]
	
	var currObj
	for i in doorData.values():
		currObj=door.instantiate()
		
		add_child(currObj)
		currObj.place(i["startCoords"],0,i["rotation"])
	
	
	var wallData=mapData["innerWalls"]
	
	for i in wallData.values():
		currObj=genericCube.instantiate()
		
		add_child(currObj)
		currObj.place(i["startCoords"],0,i["size"],wallHeight)
	
	var coverData=mapData["cover"]
	
	for i in coverData.values():
		currObj=genericCube.instantiate()
		
		add_child(currObj)
		currObj.place(i["startCoords"],0,i["size"],coverHeight)
		
	
	var playerStart=mapData["opStart"]["startCoords"]
	
	player.position=Vector3(playerStart[0],3,playerStart[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
