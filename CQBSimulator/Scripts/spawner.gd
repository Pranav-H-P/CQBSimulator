extends Node3D



@onready var level=get_parent()

var xExtents = 0
var zExtents = 0
var enemyData=[]
var spawnerId
var spawnedList=[]
var positionArray=[]
var fitnessArr=[]
var alive=99999
var topPerc=0.5
var mutationPerc=0.1
var spawnX
var spawnZ


const enemy = preload("res://Nodes/Enemy.tscn")

func returnFitnessValue(val,enemyId):
	alive-=1
	fitnessArr[enemyId]=val
	

func activate():
	spawnX=global_position.x
	spawnZ=global_position.z
	var count=0
	if len(enemyData)==0:
		roundEnd()
		queue_free()
		
	for i in enemyData:
		var enem = enemy.instantiate()
		spawnedList.append(enem)
		add_child(enem)
		enem.enemySetup(i)
		fitnessArr.append(0)
		
		
		if GLOBALS.currRound==1:
			positionArray.append([GLOBALS.RNG.randf_range(spawnX,spawnX+xExtents),
			GLOBALS.RNG.randf_range(spawnZ,spawnZ+zExtents)])
			enem.global_position.y=0.25;
			enem.global_position.x=positionArray[count][0]
			enem.global_position.z=positionArray[count][1]
			enem.enemyId=count
		else:
			#do stuff with position array etc for neat
			enem.global_position.y=0.25;
			enem.global_position.x=positionArray[count][0]
			enem.global_position.z=positionArray[count][1]
			enem.enemyId=count
			
		count+=1
	alive=count
	
	
func sortRanked(a, b):
	if a[0] > b[0]:
		return true
	return false

func roundEnd():
	
	if len(enemyData)==0: #empty spawner
		level.spawnerDone(spawnerId,enemyData,positionArray.duplicate(true))
		
	else:
		
		var rankedPositions=[]
		for i in range(len(positionArray)):
			rankedPositions.append([ fitnessArr[i], positionArray[i] ])
		
		rankedPositions.sort_custom(sortRanked)
		
		var bestX=[]
		var bestZ=[]
		
		for i in range(max(1,ceili(len(rankedPositions)*topPerc))):
			bestX.append(rankedPositions[i][1][0])
			bestZ.append(rankedPositions[i][1][1])
		
		var newPositions=[]
		var newX
		var newZ
		
		for i in range(len(positionArray)):
			newX=clampf(bestX[GLOBALS.RNG.randf_range(0,len(bestX)-1)] + \
			randf_range(-xExtents*mutationPerc,xExtents*mutationPerc),spawnX,spawnX+xExtents)
			newZ=clampf(bestZ[GLOBALS.RNG.randf_range(0,len(bestZ)-1)] + \
			randf_range(-zExtents*mutationPerc,zExtents*mutationPerc),spawnZ,spawnZ+zExtents)
			
			newPositions.append([newX,newZ])
		
		level.spawnerDone(spawnerId,enemyData,newPositions.duplicate(true))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive==0:
		roundEnd()
		#add saving feature
		set_process(false)
