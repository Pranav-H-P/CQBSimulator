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

const enemy = preload("res://Nodes/Enemy.tscn")

func returnFitnessValue(val,enemyId):
	alive-=1
	fitnessArr[enemyId]=val
	

func activate():
	print("spawner id: ",spawnerId,enemyData,positionArray)
	var spawnX=global_position.x
	var spawnZ=global_position.z
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
			positionArray.append([GLOBALS.RNG.randi_range(spawnX,spawnX+xExtents),
			GLOBALS.RNG.randi_range(spawnZ,spawnZ+zExtents)])
			enem.global_position.y=0.25;
			enem.global_position.x=positionArray[count][0]
			enem.global_position.z=positionArray[count][1]
			enem.enemyId=count
		else:
			print("count: ",count)
			#do stuff with position array etc for neat
			enem.global_position.y=0.25;
			enem.global_position.x=positionArray[count][0]
			enem.global_position.z=positionArray[count][1]
			enem.enemyId=count
			
		count+=1
	alive=count
	
func roundEnd():
	level.spawnerDone(spawnerId,enemyData,positionArray.duplicate(true))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive==0:
		roundEnd()
		#add saving feature
		set_process(false)
